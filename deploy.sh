#!/bin/bash

# Ticket Colombia Deployment Script
# Usage: ./deploy.sh [dev|prod]

set -e

ENVIRONMENT=${1:-dev}

echo "🚀 Deploying Ticket Colombia - Environment: $ENVIRONMENT"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from production.env template..."
    cp production.env .env
    echo "⚠️  Please edit .env file with your configuration before running again."
    exit 1
fi

# Function to deploy development
deploy_dev() {
    echo "🔧 Deploying development environment..."
    
    # Stop existing containers
    docker-compose down 2>/dev/null || true
    
    # Build and start services
    docker-compose up --build -d
    
    echo "✅ Development deployment complete!"
    echo "🌐 Frontend: http://localhost:3000"
    echo "🔗 Backend API: http://localhost:8080"
    echo "📊 Health Check: http://localhost:8080/health"
}

# Function to deploy production
deploy_prod() {
    echo "🏭 Deploying production environment..."
    
    # Stop existing containers
    docker-compose -f docker-compose.yml down 2>/dev/null || true
    
    # Build and start services
    docker-compose -f docker-compose.yml up --build -d
    
    echo "✅ Production deployment complete!"
    echo "🌐 Application should be available on your configured domain"
}

# Function to show logs
show_logs() {
    echo "📋 Showing logs for all services..."
    docker-compose logs -f
}

# Function to show status
show_status() {
    echo "📊 Service Status:"
    docker-compose ps
}

# Function to clean up
cleanup() {
    echo "🧹 Cleaning up Docker resources..."
    docker-compose down
    docker system prune -f
    echo "✅ Cleanup complete!"
}

# Main script logic
case $ENVIRONMENT in
    "dev")
        deploy_dev
        ;;
    "prod")
        deploy_prod
        ;;
    "logs")
        show_logs
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        cleanup
        ;;
    *)
        echo "Usage: $0 [dev|prod|logs|status|cleanup]"
        echo ""
        echo "Commands:"
        echo "  dev     - Deploy development environment"
        echo "  prod    - Deploy production environment"
        echo "  logs    - Show logs for all services"
        echo "  status  - Show status of all services"
        echo "  cleanup - Clean up Docker resources"
        exit 1
        ;;
esac
