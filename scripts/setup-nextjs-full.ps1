# Enhanced Next.js Landing Page Setup with Vercel Deployment
# Version: 2.0
# Features: Interactive setup, GitHub integration, Vercel deployment, domain configuration

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

# Import functions
. "$PSScriptRoot\functions\helpers.ps1"

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

function Get-EnvTemplate {
    $envTemplatePath = Join-Path $PSScriptRoot "../templates/env-template.txt"
    if (Test-Path $envTemplatePath) {
        return Get-Content $envTemplatePath -Raw
    } else {
        return @"
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project-url.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# Resend Configuration
RESEND_API_KEY=your-resend-api-key-here

# App Configuration
NEXT_PUBLIC_APP_URL=https://yourdomain.com
"@
    }
}

Write-Host "🚀 Next.js Landing Page Setup with Full Deployment" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan

# Get project details
$ProjectName = Read-Host "Enter project name (e.g., my-landing-page)"
$ProjectTitle = Read-Host "Enter project title for the landing page"
$ProjectMessage = Read-Host "Enter tagline/message (default: 'Something amazing is coming soon')"
$CustomDomain = Read-Host "Enter custom domain (optional, e.g., myproject.com)"

if ([string]::IsNullOrWhiteSpace($ProjectMessage)) {
    $ProjectMessage = "Something amazing is coming soon"
}

$CreateGitHub = Read-Host "Create GitHub repository? (y/n, default: y)"
if ([string]::IsNullOrWhiteSpace($CreateGitHub)) {
    $CreateGitHub = "y"
}

$DeployVercel = Read-Host "Deploy to Vercel automatically? (y/n, default: y)"
if ([string]::IsNullOrWhiteSpace($DeployVercel)) {
    $DeployVercel = "y"
}

Write-Host ""
Write-Host "Project Configuration:" -ForegroundColor Yellow
Write-Host "  Name: $ProjectName" -ForegroundColor Gray
Write-Host "  Title: $ProjectTitle" -ForegroundColor Gray
Write-Host "  Message: $ProjectMessage" -ForegroundColor Gray
Write-Host "  Domain: $(if($CustomDomain) {$CustomDomain} else {'Auto-generated'})" -ForegroundColor Gray
Write-Host "  GitHub: $CreateGitHub" -ForegroundColor Gray
Write-Host "  Vercel: $DeployVercel" -ForegroundColor Gray
Write-Host ""

# Step 1: Create Next.js project
Write-Host "⏳ Creating Next.js project..." -ForegroundColor Yellow
Set-Location $ProjectPath
npx create-next-app@latest $ProjectName --yes --silent
Test-CommandSuccess "Next.js project created"

Set-Location $ProjectName

# Step 2: Install dependencies
Write-Host "⏳ Installing dependencies..." -ForegroundColor Yellow
npm install @supabase/supabase-js clsx tailwind-merge date-fns lucide-react resend --silent
Test-CommandSuccess "Dependencies installed"

# Step 3: Initialize shadcn/ui
Write-Host "⏳ Initializing shadcn/ui..." -ForegroundColor Yellow
npx shadcn@latest init --defaults --silent
Test-CommandSuccess "shadcn/ui initialized"

# Step 4: Install UI components
Write-Host "⏳ Installing UI components..." -ForegroundColor Yellow
npx shadcn@latest add button card badge separator avatar navigation-menu input textarea --silent
Test-CommandSuccess "UI components installed"

# Step 5: Create landing page with proper escaping
Write-Host "⏳ Creating customized landing page..." -ForegroundColor Yellow

$appPath = if (Test-Path "app") { "app" } else { "src/app" }

# Escape special characters for JSX
$EscapedTitle = $ProjectTitle -replace "'", "&apos;"
$EscapedMessage = $ProjectMessage -replace "'", "&apos;"

$LandingPageContent = @"
export default function HomePage() {
  return (
    <main className="min-h-screen bg-white">
      {/* Hero Section */}
      <section className="container mx-auto px-4 py-24 text-center">
        <div className="inline-block px-3 py-1 mb-6 text-sm bg-blue-100 text-blue-800 rounded-full">
          ✨ Coming Soon
        </div>
        <h1 className="text-4xl md:text-6xl font-bold mb-6 text-gray-900">
          $EscapedTitle
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
          $EscapedMessage
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
          <button className="px-8 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors font-semibold">
            Get Notified
          </button>
          <button className="px-8 py-3 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
            Learn More
          </button>
        </div>
      </section>

      {/* Features Section */}
      <section className="container mx-auto px-4 py-16 bg-gray-50">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">What&apos;s Coming</h2>
          <p className="text-gray-600 max-w-2xl mx-auto">
            We&apos;re building something special. Stay tuned for updates.
          </p>
        </div>
        
        <div className="grid md:grid-cols-3 gap-8 max-w-4xl mx-auto">
          <div className="text-center">
            <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-blue-600 text-2xl">🚀</span>
            </div>
            <h3 className="text-xl font-semibold mb-2 text-gray-900">Fast</h3>
            <p className="text-gray-600">Built with modern technology for optimal performance.</p>
          </div>
          
          <div className="text-center">
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-green-600 text-2xl">✨</span>
            </div>
            <h3 className="text-xl font-semibold mb-2 text-gray-900">Beautiful</h3>
            <p className="text-gray-600">Designed with attention to detail and user experience.</p>
          </div>
          
          <div className="text-center">
            <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <span className="text-purple-600 text-2xl">🎯</span>
            </div>
            <h3 className="text-xl font-semibold mb-2 text-gray-900">Powerful</h3>
            <p className="text-gray-600">Feature-rich and ready for your needs.</p>
          </div>
        </div>
      </section>

      {/* Newsletter Section */}
      <section className="container mx-auto px-4 py-24 text-center">
        <h2 className="text-3xl font-bold mb-4 text-gray-900">Stay Updated</h2>
        <p className="text-gray-600 mb-8 max-w-md mx-auto">
          Be the first to know when we launch. No spam, just updates.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center items-center max-w-md mx-auto">
          <input 
            type="email" 
            placeholder="Enter your email" 
            className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors whitespace-nowrap">
            Notify Me
          </button>
        </div>
      </section>
    </main>
  )
}
"@

$LandingPageContent | Out-File -FilePath "$appPath/page.tsx" -Encoding UTF8
Test-CommandSuccess "Customized landing page created"

# Step 6: Setup environment
Write-Host "⏳ Setting up environment..." -ForegroundColor Yellow

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

$envContent = Get-EnvTemplate
$envContent | Out-File -FilePath ".env.local" -Encoding UTF8

Test-CommandSuccess "Environment setup completed"

# Step 7: Test build
Write-Host "⏳ Testing build..." -ForegroundColor Yellow
npm run build --silent
Test-CommandSuccess "Build test passed"

# Step 8: Git setup
Write-Host "⏳ Setting up Git..." -ForegroundColor Yellow
git init | Out-Null
git add . | Out-Null
git commit -m "Initial setup: $ProjectTitle" | Out-Null
Test-CommandSuccess "Git initialized"

# Step 9: GitHub repository
if ($CreateGitHub -eq "y" -or $CreateGitHub -eq "Y") {
    Write-Host "⏳ Creating GitHub repository..." -ForegroundColor Yellow
    gh repo create $ProjectName --public --source=. --remote=origin --push | Out-Null
    Test-CommandSuccess "GitHub repository created"
}

# Step 10: Vercel deployment
if ($DeployVercel -eq "y" -or $DeployVercel -eq "Y") {
    Write-Host "⏳ Deploying to Vercel..." -ForegroundColor Yellow
    
    # Check if Vercel CLI is installed
    if (!(Get-Command vercel -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Vercel CLI..." -ForegroundColor Gray
        npm install -g vercel@latest
    }
    
    # Deploy to Vercel
    vercel --yes --token $env:VERCEL_TOKEN | Out-Null
    Test-CommandSuccess "Deployed to Vercel"
    
    # Set custom domain if provided
    if ($CustomDomain) {
        Write-Host "⏳ Setting up custom domain..." -ForegroundColor Yellow
        vercel domains add $CustomDomain --token $env:VERCEL_TOKEN | Out-Null
        vercel alias set $CustomDomain --token $env:VERCEL_TOKEN | Out-Null
        Test-CommandSuccess "Custom domain configured"
    }
}

# Final success message
Write-Host ""
Write-Host "🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "Project: $ProjectTitle" -ForegroundColor Cyan
Write-Host "Location: $ProjectPath\$ProjectName" -ForegroundColor Gray

if ($CreateGitHub -eq "y" -or $CreateGitHub -eq "Y") {
    Write-Host "GitHub: https://github.com/$(gh api user --jq .login)/$ProjectName" -ForegroundColor Yellow
}

if ($DeployVercel -eq "y" -or $DeployVercel -eq "Y") {
    if ($CustomDomain) {
        Write-Host "Live URL: https://$CustomDomain" -ForegroundColor Green
    }
    Write-Host "Vercel URL: https://$ProjectName.vercel.app" -ForegroundColor Yellow
}

Write-Host "Local: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""

# Auto-start development server
Write-Host "🚀 Starting development server..." -ForegroundColor Green
Start-Sleep -Seconds 2
npm run dev
