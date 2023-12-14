#!/bin/bash

# Parameters
region="${1//[[:space:]]/}"
resourceId="${2//[[:space:]]/}"
connectionString="${3//[[:space:]]/}"

# Logging
echo "Region: [$region]"
echo "ResourceID: [$resourceId]"

# Install jq if not present
command -v jq || sudo apt install -y jq

# Install Node.js using nvm
touch ~/.bashrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh
nvm install node

# Create and navigate to the application directory
mkdir test-app
cd test-app

# Initialize a new Node.js project
npm init -y

# Install Application Insights
npm i --save applicationinsights

# Export the connection string to an environment variable
export APPINSIGHTS_CONNECTIONSTRING="${connectionString}"

# Create a Node.js script using a heredoc
cat << 'EOF' > app.js
const appInsights = require('applicationinsights');
appInsights.setup().start();

const client = appInsights.defaultClient;

// Example URL for the login link
const loginLinkUrl = "https://example.com/login?token=abc123";

// Sending a custom event
client.trackEvent({name: "LoginLink", properties: {url: loginLinkUrl}});

console.log('Custom event sent to Application Insights');
EOF

# Run the Node.js script
node app.js

exit 0

