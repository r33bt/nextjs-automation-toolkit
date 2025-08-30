# Save this as "setup-nextjs-automated.ps1"

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# Function to check if command succeeded and exit on failure
function Test-CommandSuccess {
    param([string]$StepName)
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed at step: $StepName" -ForegroundColor Red
        Write-Host "Exiting setup..." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "✅ $StepName" -ForegroundColor Green
    }
}

# Function to read environment template
function Get-EnvTemplate {
    $envTemplatePath = Join-Path $PSScriptRoot "env-template.txt"
    if (Test-Path $envTemplatePath) {
        return Get-Content $envTemplatePath -Raw
    } else {
        return @"
# Replace with your actual Supabase project URL and anon key
NEXT_PUBLIC_SUPABASE_URL=your_project_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
"@
    }
}

Write-Host "🚀 Automated Next.js Landing Page Setup" -ForegroundColor Cyan
Write-Host "Project: $ProjectName at $ProjectPath" -ForegroundColor Gray
Write-Host "═══════════════════════════════════════" -ForegroundColor Cyan

# Step 1: Create Next.js project
Write-Host "⏳ Creating Next.js project..." -ForegroundColor Yellow
Set-Location $ProjectPath
npx create-next-app@latest $ProjectName --yes --silent
Test-CommandSuccess "Next.js project created"

Set-Location $ProjectName

# Step 2: Install dependencies
Write-Host "⏳ Installing dependencies..." -ForegroundColor Yellow
npm install @supabase/supabase-js clsx tailwind-merge date-fns lucide-react --silent
Test-CommandSuccess "Dependencies installed"

# Step 3: Initialize shadcn/ui
Write-Host "⏳ Initializing shadcn/ui..." -ForegroundColor Yellow
npx shadcn@latest init --defaults --silent
Test-CommandSuccess "shadcn/ui initialized"

# Step 4: Install UI components
Write-Host "⏳ Installing UI components..." -ForegroundColor Yellow
npx shadcn@latest add button card badge separator avatar navigation-menu --silent
Test-CommandSuccess "UI components installed"

# Step 5: Create landing page
Write-Host "⏳ Creating landing page..." -ForegroundColor Yellow

# Detect if we have app/ or src/app/ structure
$appPath = if (Test-Path "app") { "app" } else { "src/app" }

$LandingPageContent = @"
export default function HomePage() {
  return (
    <main className="min-h-screen bg-white">
      {/* Hero Section */}
      <section className="container mx-auto px-4 py-24 text-center">
        <div className="inline-block px-3 py-1 mb-4 text-sm bg-blue-100 text-blue-800 rounded-full">
          ✨ $ProjectName Launch
        </div>
        <h1 className="text-4xl md:text-6xl font-bold mb-6 text-gray-900">
          Build Something Amazing
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          Create beautiful landing pages with Next.js, shadcn/ui, and Supabase.
          Fast, modern, and ready for production.
        </p>
        <div className="flex gap-4 justify-center">
          <button className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
            Get Started
          </button>
          <button className="px-6 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
            Learn More
          </button>
        </div>
      </section>

      {/* Features Section */}
      <section className="container mx-auto px-4 py-24 bg-gray-50">
        <h2 className="text-3xl font-bold text-center mb-12 text-gray-900">Key Features</h2>
        <div className="grid md:grid-cols-3 gap-8">
          <div className="bg-white p-6 rounded-lg shadow-sm text-center border border-gray-100">
            <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-blue-600 text-xl">⚡</span>
            </div>
            <h3 className="text-xl font-semibold mb-4 text-gray-900">Fast & Modern</h3>
            <p className="text-gray-600">Built with Next.js 15 and React 19 for optimal performance and modern development.</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow-sm text-center border border-gray-100">
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-green-600 text-xl">🎨</span>
            </div>
            <h3 className="text-xl font-semibold mb-4 text-gray-900">Beautiful UI</h3>
            <p className="text-gray-600">Styled with shadcn/ui components and Tailwind CSS for stunning designs.</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow-sm text-center border border-gray-100">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <span className="text-purple-600 text-xl">🚀</span>
            </div>
            <h3 className="text-xl font-semibold mb-4 text-gray-900">Database Ready</h3>
            <p className="text-gray-600">Integrated with Supabase for backend functionality and real-time features.</p>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-4 py-24 text-center bg-gradient-to-r from-blue-50 to-indigo-50">
        <h2 className="text-3xl font-bold mb-6 text-gray-900">Ready to Get Started?</h2>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          Join thousands of developers building amazing products with our modern stack.
        </p>
        <button className="px-8 py-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold shadow-lg">
          Start Building Now
        </button>
      </section>
    </main>
  )
}
"@

$LandingPageContent | Out-File -FilePath "$appPath/page.tsx" -Encoding UTF8
Test-CommandSuccess "Landing page created"

# Step 6: Setup Supabase
Write-Host "⏳ Setting up Supabase..." -ForegroundColor Yellow

# Detect lib path
$libPath = if (Test-Path "lib") { "lib" } else { "src/lib" }
if (!(Test-Path $libPath)) {
    New-Item -ItemType Directory -Path $libPath -Force | Out-Null
}

$SupabaseContent = @"
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
"@

$SupabaseContent | Out-File -FilePath "$libPath/supabase.ts" -Encoding UTF8

# Create environment file
$envContent = Get-EnvTemplate
$envContent | Out-File -FilePath ".env.local" -Encoding UTF8

Test-CommandSuccess "Supabase setup completed"

# Step 7: Test build
Write-Host "⏳ Testing build..." -ForegroundColor Yellow
npm run build --silent
Test-CommandSuccess "Build test passed"

# Step 8: Git setup
Write-Host "⏳ Setting up Git..." -ForegroundColor Yellow
git init | Out-Null
git add . | Out-Null
git commit -m "Initial automated Next.js landing page setup" | Out-Null
Test-CommandSuccess "Git initialized"

# Step 9: Create GitHub repository (optional)
$createRepo = $env:AUTO_CREATE_GITHUB_REPO
if ($createRepo -eq "true") {
    Write-Host "⏳ Creating GitHub repository..." -ForegroundColor Yellow
    gh repo create $ProjectName --public --source=. --remote=origin --push | Out-Null
    Test-CommandSuccess "GitHub repository created"
}

# Final success message
Write-Host ""
Write-Host "🎉 SETUP COMPLETE!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "Project: $ProjectName" -ForegroundColor Cyan
Write-Host "Location: $ProjectPath\$ProjectName" -ForegroundColor Gray
Write-Host "URL: http://localhost:3000" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Update .env.local with your Supabase credentials" -ForegroundColor White
Write-Host "2. Deploy to Vercel" -ForegroundColor White
Write-Host ""

# Auto-start development server
Write-Host "🚀 Starting development server..." -ForegroundColor Green
npm run dev
