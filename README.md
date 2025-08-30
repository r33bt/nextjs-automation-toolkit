# Next.js Landing Page Automation Toolkit

A comprehensive toolkit for automating Next.js landing page creation, GitHub repository setup, and Vercel deployment. This project evolved from manual setup processes to fully automated workflows.

## 🎯 Project Overview

This toolkit solves the common problem of repeatedly setting up Next.js landing pages with the same configuration:
- Next.js 15 with TypeScript and Tailwind CSS
- shadcn/ui components for beautiful UI
- Supabase integration for backend services
- Resend for email functionality
- GitHub repository creation
- Vercel deployment automation

## 📁 Project Structure

00-nextjs-automation-toolkit/ ├── scripts/ │ ├── setup-nextjs-landing.ps1 # Original basic script │ ├── setup-nextjs-automated.ps1 # No-prompt automation │ ├── setup-nextjs-interactive.ps1 # Interactive with confirmations │ └── setup-nextjs-with-defaults.ps1 # Latest - Smart defaults ⭐ ├── templates/ │ └── env-template.txt # Environment variable template ├── docs/ └── README.md # This file


## 🚀 Scripts Overview

### 1. `setup-nextjs-landing.ps1` (Original)
**Status: Legacy**
- Basic Next.js project creation
- Manual component setup
- No automation
- Used for initial proof of concept

**Usage:**
```powershell
.\scripts\setup-nextjs-landing.ps1 -ProjectPath "C:\path" -ProjectName "my-project"
2. setup-nextjs-automated.ps1 (V1)
Status: Deprecated

Fully automated (no user input)
Fixed project templates
No customization options
Prone to errors due to bulk command execution
Issues:

Bulk command execution caused failures
No user control over project details
Hard to debug when things went wrong
3. setup-nextjs-interactive.ps1 (V1.5)
Status: Working but superseded

Interactive prompts for all settings
Step-by-step confirmation required
GitHub integration
Manual Vercel deployment
Features:

Custom project names and messages
GitHub repository creation
Environment variable setup
Sequential command execution (fixes bulk command issues)
Usage:

Copy.\scripts\setup-nextjs-interactive.ps1 -ProjectPath "C:\path\to\projects"
4. setup-nextjs-with-defaults.ps1 (V2 - Current) ⭐
Status: Latest and Recommended

Key Improvements:

Smart defaults: Press Enter to use sensible defaults
Time-based naming: Auto-generates project names with timestamps
Error handling: Proper JSX character escaping
Flexible input: Override any default when needed
Clean output: Better progress indicators and success messages
Default Values:

Project name: landing-page-MMDD-HHMM (e.g., landing-page-0830-1245)
Project title: Amazing Landing Page
Tagline: Something amazing is coming soon
GitHub repo: Yes
Vercel deployment: No (manual for now)
Usage:

Copy# Quick setup with all defaults (just press Enter 5 times)
.\scripts\setup-nextjs-with-defaults.ps1 -ProjectPath "C:\Users\user\alphadev2\_active-projects"

# Or provide custom values when prompted
🛠 What Each Script Does
All scripts follow this general workflow:

Create Next.js Project

Uses create-next-app@latest with TypeScript, Tailwind, App Router
Installs in specified directory
Install Dependencies

Supabase client (@supabase/supabase-js)
Utility libraries (clsx, tailwind-merge, date-fns, lucide-react)
Email service (resend)
Setup shadcn/ui

Initialize with defaults
Install common components: button, card, badge, separator, avatar, navigation-menu, input, textarea
Create Landing Page

Custom hero section with project title and message
Features section with icons and descriptions
Email signup section
Responsive design with Tailwind CSS
Environment Setup

Create .env.local with Supabase and Resend placeholders
Setup lib/supabase.ts client configuration
Git Integration

Initialize git repository
Commit initial setup
Create GitHub repository (optional)
Push to remote
Deployment Ready

Test build to ensure everything works
Provide Vercel deployment instructions
Auto-start development server
🔧 Prerequisites
Before running any script, ensure you have:

Node.js 18.18+ - For Next.js development
GitHub CLI (gh) - For repository creation
Copywinget install --id GitHub.cli
gh auth login
PowerShell ExecutionPolicy - Set to allow script execution
CopySet-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
📝 Environment Variables
The scripts create a .env.local file with these placeholders:

# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project-url.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# Resend Configuration  
RESEND_API_KEY=your-resend-api-key-here

# App Configuration
NEXT_PUBLIC_APP_URL=https://yourdomain.com
🚀 Quick Start
Clone or download this toolkit
Navigate to the directory
Copycd "C:\path\to\00-nextjs-automation-toolkit"
Run the latest script
Copy.\scripts\setup-nextjs-with-defaults.ps1 -ProjectPath "C:\your\projects\directory"
Press Enter for defaults or customize as needed
Your landing page will be created, committed to GitHub, and ready for Vercel deployment
🌐 Deployment to Vercel
After the script completes:

Go to vercel.com/new
Import your newly created GitHub repository
Add environment variables from your .env.local file
Deploy!
The script provides direct links to make this process seamless.

🐛 Troubleshooting
Common Issues:
PowerShell Execution Policy Error

CopySet-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
GitHub CLI Not Authenticated

Copygh auth login
Build Fails with JSX Errors

The latest script handles character escaping automatically
Older scripts may have issues with apostrophes in text
Node.js Version Issues

Ensure Node.js 18.18+ is installed
Check with: node --version
📈 Evolution & Lessons Learned
Key Problems Solved:
Bulk Command Execution → Sequential Processing

Original scripts tried to run multiple commands at once
Fixed by adding proper error checking and step-by-step execution
No User Control → Smart Defaults

First automation had no customization
Evolution to interactive prompts with sensible defaults
Manual Vercel Setup → Automated Instructions

While full Vercel CLI automation is possible, manual import is often preferred
Scripts now provide exact steps and links
Complex Project Structure → Organized Toolkit

Started as loose scripts in project directory
Evolved to proper toolkit with version control and documentation
🔮 Future Enhancements
 Full Vercel CLI automation with token management
 Custom domain configuration
 Multiple landing page templates
 Database schema setup automation
 Email template integration
 Analytics integration (Vercel Analytics, Google Analytics)
 SEO optimization automation
🤝 Contributing
This toolkit is designed to be extended. When adding new features:

Create new scripts in the scripts/ directory
Update this README with documentation
Test thoroughly with different configurations
Maintain backward compatibility where possible
📊 Success Metrics
A successful run of the latest script should:

✅ Create a working Next.js project in under 2 minutes
✅ Generate a professional-looking landing page
✅ Push to GitHub automatically
✅ Provide clear next steps for deployment
✅ Require minimal user input (5 prompts max)
Last Updated: $(Get-Date -Format 'yyyy-MM-dd') Latest Script: setup-nextjs-with-defaults.ps1 Tested On: Windows 11, PowerShell 7+, Node.js 20+ "@ | Out-File -FilePath "README.md" -Encoding UTF8

Create package.json for the toolkit
@" { "name": "nextjs-automation-toolkit", "version": "2.0.0", "description": "Automated Next.js landing page creation and deployment toolkit", "scripts": { "setup": "powershell -ExecutionPolicy Bypass -File scripts/setup-nextjs-with-defaults.ps1" }, "keywords": ["nextjs", "automation", "landing-page", "vercel", "github"], "author": "Development Team", "license": "MIT" } "@ | Out-File -FilePath "package.json" -Encoding UTF8

Create a simple changelog
@"

Changelog
[2.0.0] - $(Get-Date -Format 'yyyy-MM-dd')
Added
Smart defaults for all prompts
Time-based project naming
Proper JSX character escaping
Comprehensive error handling
Organized project structure
Fixed
Bulk command execution issues
PowerShell escaping problems
Build failures due to unescaped characters
[1.5.0] - Previous
Added
Interactive prompts
GitHub integration
Step-by-step execution
[1.0.0] - Initial
Added
Basic Next.js project creation
shadcn/ui integration
Supabase setup "@ | Out-File -FilePath "CHANGELOG.md" -Encoding UTF8