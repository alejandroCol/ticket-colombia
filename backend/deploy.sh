#!/bin/bash

# Ticket Colombia - Production Deployment Script
# This script sets up the production environment

echo "🚀 Starting Ticket Colombia Production Deployment..."

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL first."
    exit 1
fi

# Set environment variables
export DATABASE_URL="jdbc:postgresql://localhost:5432/ticketcolombia"
export DATABASE_USERNAME="ticketcolombia"
export DATABASE_PASSWORD="ticketcolombia123"
export JWT_SECRET="your-super-secret-jwt-key-change-in-production"
export RESEND_API_KEY="re_NpMHqGuU_NuKJqwEpKRATj378NU8hTYUG"
export FROM_EMAIL="onboarding@resend.dev"

# Create database and user
echo "📊 Setting up database..."
sudo -u postgres psql -c "CREATE DATABASE ticketcolombia;" 2>/dev/null || echo "Database might already exist"
sudo -u postgres psql -c "CREATE USER ticketcolombia WITH PASSWORD 'ticketcolombia123';" 2>/dev/null || echo "User might already exist"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ticketcolombia TO ticketcolombia;" 2>/dev/null || echo "Privileges might already be granted"

# Build the application
echo "🔨 Building application..."
./gradlew clean build

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "🌐 Starting application on port 8080..."
    echo "📱 API will be available at: http://localhost:8080"
    echo "🔍 Health check: http://localhost:8080/health"
    echo ""
    echo "📋 Available endpoints:"
    echo "  POST /auth/register - Register user"
    echo "  POST /auth/login - Login user"
    echo "  GET /auth/me - Get current user"
    echo "  GET /events - List events"
    echo "  POST /events - Create event"
    echo "  GET /events/{id} - Get event by ID"
    echo "  GET /tickets?eventId={id} - Get tickets for event"
    echo "  POST /tickets - Create ticket"
    echo "  POST /tickets/validate - Validate ticket"
    echo ""
    echo "🚀 Starting server..."
    ./gradlew run
else
    echo "❌ Build failed!"
    exit 1
fi
