#!/bin/bash

echo "🚀 Starting deployment process..."

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Check if npm is installed
if ! command_exists npm ; then
    echo "❌ npm is not installed. Please install Node.js and npm first."
    exit 1
fi

# Check if git is installed
if ! command_exists git ; then
    echo "❌ git is not installed. Please install git first."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Run tests if they exist
if grep -q "\"test\"" package.json; then
    echo "🧪 Running tests..."
    npm test
fi

# Build the project
echo "🏗️ Building the project..."
npm run build

# Choose deployment platform
echo "📋 Please choose deployment platform:"
echo "1) GitHub Pages"
echo "2) Vercel"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "🚀 Deploying to GitHub Pages..."
        # Check if gh-pages is installed
        if ! grep -q "\"gh-pages\"" package.json; then
            echo "📦 Installing gh-pages..."
            npm install --save-dev gh-pages
        fi
        
        # Deploy to GitHub Pages
        npm run deploy
        ;;
    2)
        echo "🚀 Deploying to Vercel..."
        # Check if vercel is installed
        if ! command_exists vercel ; then
            echo "📦 Installing Vercel CLI..."
            npm install -g vercel
        fi
        
        # Check if user is logged in to Vercel
        if ! vercel whoami &> /dev/null ; then
            echo "🔑 Please login to Vercel..."
            vercel login
        fi
        
        # Deploy to Vercel
        echo "Choose Vercel deployment type:"
        echo "1) Preview deployment"
        echo "2) Production deployment"
        read -p "Enter your choice (1 or 2): " vercel_choice
        
        case $vercel_choice in
            1)
                npm run deploy:vercel
                ;;
            2)
                npm run deploy:vercel-prod
                ;;
            *)
                echo "❌ Invalid choice. Exiting..."
                exit 1
                ;;
        esac
        ;;
    *)
        echo "❌ Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo "✅ Deployment completed!" 