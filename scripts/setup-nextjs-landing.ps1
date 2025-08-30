# Save this as "setup-nextjs-landing.ps1"

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# Function to check if command succeeded
function Test-LastCommand {
    param([string]$StepName)
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed at step: $StepName" -ForegroundColor Red
        exit 1
    } else {
        Write-Host "✅ Completed: $StepName" -ForegroundColor Green
    }
}

# Function to wait for user confirmation
function Wait-ForConfirmation {
    param([string]$Message)
    Write-Host $Message -ForegroundColor Yellow
    Read-Host "Press Enter to continue, or Ctrl+C to stop"
}

Write-Host "🚀 Setting up Next.js Landing Page Project" -ForegroundColor Cyan
Write-Host "Project Path: $ProjectPath" -ForegroundColor Gray
Write-Host "Project Name: $ProjectName" -ForegroundColor Gray
Write-Host ""

# Step 1: Navigate and create project
Write-Host "Step 1: Creating Next.js project..." -ForegroundColor Yellow
cd $ProjectPath
npx create-next-app@latest $ProjectName --yes
Test-LastCommand "Next.js project creation"

cd $ProjectName
Wait-ForConfirmation "✅ Next.js created. Test with 'npm run dev' if you want to verify."

# Step 2: Install dependencies
Write-Host "Step 2: Installing dependencies..." -ForegroundColor Yellow
npm install @supabase/supabase-js clsx tailwind-merge date-fns lucide-react
Test-LastCommand "Dependencies installation"

Wait-ForConfirmation "✅ Dependencies installed."

# Step 3: Initialize shadcn/ui
Write-Host "Step 3: Initializing shadcn/ui..." -ForegroundColor Yellow
npx shadcn@latest init --defaults
Test-LastCommand "shadcn/ui initialization"

Wait-ForConfirmation "✅ shadcn/ui initialized."

# Step 4: Install UI components
Write-Host "Step 4: Installing UI components..." -ForegroundColor Yellow
npx shadcn@latest add button card badge separator avatar navigation-menu
Test-LastCommand "UI components installation"

Wait-ForConfirmation "✅ UI components installed."

# Step 5: Create simple landing page
Write-Host "Step 5: Creating landing page..." -ForegroundColor Yellow
$LandingPageContent = @"
export default function HomePage() {
  return (
    <main className="min-h-screen bg-white">
      {/* Hero Section */}
      <section className="container mx-auto px-4 py-24 text-center">
        <div className="inline-block px-3 py-1 mb-4 text-sm bg-blue-100 text-blue-800 rounded-full">
          ✨ New Launch
        </div>
        <h1 className="text-4xl md:text-6xl font-bold mb-6 text-gray-900">
          Build Something Amazing
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          Create beautiful landing pages with Next.js, shadcn/ui, and Supabase.
          Fast, modern, and ready for production.
        </p>
        <div className="flex gap-4 justify-center">
          <button className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
            Get Started
          </button>
          <button className="px-6 py-3 border border-gray-300 rounded-lg hover:bg-gray-50">
            Learn More
          </button>
        </div>
      </section>

      {/* Features Section */}
      <section className="container mx-auto px-4 py-24 bg-gray-50">
        <h2 className="text-3xl font-bold text-center mb-12">Key Features</h2>
        <div className="grid md:grid-cols-3 gap-8">
          <div className="bg-white p-6 rounded-lg shadow-sm text-center">
            <h3 className="text-xl font-semibold mb-4">Fast & Modern</h3>
            <p className="text-gray-600">Built with Next.js 15 and React 19 for optimal performance.</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow-sm text-center">
            <h3 className="text-xl font-semibold mb-4">Beautiful UI</h3>
            <p className="text-gray-600">Styled with shadcn/ui components and Tailwind CSS.</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow-sm text-center">
            <h3 className="text-xl font-semibold mb-4">Database Ready</h3>
            <p className="text-gray-600">Integrated with Supabase for backend functionality.</p>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-24 text-center">
        <h2 className="text-3xl font-bold mb-6">Ready to Get Started?</h2>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          Join thousands of developers building amazing products with our stack.
        </p>
        <button className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
          Start Building Now
        </button>
      </section>
    </main>
  )
}
"@

$LandingPageContent | Out-File -FilePath "src/app/page.tsx" -Encoding UTF8
Test-LastCommand "Landing page creation"

# Step 6: Create Supabase setup (optional)
Write-Host "Step 6: Setting up Supabase files..." -ForegroundColor Yellow
New-Item -ItemType File -Path ".env.local" -Force | Out-Null

$EnvContent = @"
# Replace with your actual Supabase project URL and anon key
NEXT_PUBLIC_SUPABASE_URL=your_project_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
"@
$EnvContent | Out-File -FilePath ".env.local" -Encoding UTF8

$SupabaseContent = @"
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
"@
$SupabaseContent | Out-File -FilePath "src/lib/supabase.ts" -Encoding UTF8

Test-LastCommand "Supabase setup"

# Step 7: Test build
Write-Host "Step 7: Testing build..." -ForegroundColor Yellow
npm run build
Test-LastCommand "Build test"

# Step 8: Git setup
Write-Host "Step 8: Setting up Git..." -ForegroundColor Yellow
git init
git add .
git commit -m "Initial Next.js landing page setup"
Test-LastCommand "Git initialization"

$CreateRepo = Read-Host "Do you want to create a GitHub repository? (y/n)"
if ($CreateRepo -eq "y" -or $CreateRepo -eq "Y") {
    gh repo create $ProjectName --public --source=. --remote=origin --push
    Test-LastCommand "GitHub repository creation"
}

Write-Host ""
Write-Host "🎉 Setup Complete!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run 'npm run dev' to start development server" -ForegroundColor White
Write-Host "2. Update .env.local with your Supabase credentials" -ForegroundColor White
Write-Host "3. Deploy to Vercel by connecting your GitHub repository" -ForegroundColor White
Write-Host ""
Write-Host "Project location: $ProjectPath\$ProjectName" -ForegroundColor Gray
