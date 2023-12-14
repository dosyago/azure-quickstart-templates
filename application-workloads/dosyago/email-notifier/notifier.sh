#!/bin/bash

adminUsername=$1  # Assuming the first argument is the admin username
region="${2//[[:space:]]/}"
resourceId="${3//[[:space:]]/}"
connectionString="${4//[[:space:]]/}"
appId="${5//[[:space:]]/}"

# Outer heredoc starts here
sudo -u "$adminUsername" bash -s "$region" "$resourceId" "$connectionString" "$appId" <<'EOF'
# Inner script starts after this line

# Parameters received from outer script
region="$1"
resourceId="$2"
connectionString="$3"
appId="$4"

# Logging
echo "Region: [$region]"
echo "ResourceID: [$resourceId]"
echo "ConnectionString: [$connectionString]"
echo "AppInsights App ID: [$appId]"

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_SUSPEND=1
export NEEDRESTART_MODE=a

# Install jq if not present
command -v jq || sudo apt install -y jq

sleep 5

# Install Node.js using nvm
cd $HOME
touch $HOME/.bashrc
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source $HOME/.nvm/nvm.sh
nvm install v20 # we need v20 for the azure libraries

# Create and navigate to the application directory
mkdir test-app
cd test-app

# Initialize a new Node.js project
npm init -y

# Install Application Insights
npm i --save applicationinsights @azure/identity @azure/monitor-query bluebird

# Export the connection string to an environment variable
export APPINSIGHTS_CONNECTION_STRING="$connectionString"
export APPINSIGHTS_APP_ID="$appId"

# Create a Node.js script using a heredoc
cat << 'INNER_EOF' > app.js
const appInsights = require('applicationinsights');
const { DefaultAzureCredential } = require('@azure/identity');
const { MetricsQueryClient } = require('@azure/monitor-query');
const { delay } = require('bluebird');

appInsights.setup(process.env.APPINSIGHTS_CONNECTION_STRING).setSendLiveMetrics(true).start();

const client = appInsights.defaultClient;

// Example URL for the login link
const loginLinkUrl = "https://example.com/login?token=abc123";

// Sending a custom event and metric
client.trackEvent({name: "LoginLink", properties: {url: loginLinkUrl}});
client.trackMetric({
  name: "LoginLink",
  value: 1,
  properties: { url: loginLinkUrl }  // Additional data
});

console.log('Custom event sent to Application Insights');

// Function to check metric availability
async function checkMetricAvailability() {
  const credential = new DefaultAzureCredential();
  const monitorQueryClient = new MonitorQueryClient(credential);
  const appId = process.env.APPINSIGHTS_APP_ID; // Set this environment variable to your Application Insights App ID
  const MAX_TRIES = 150; // around about 12 and a half minutes
  let tries = 0;
  let code = 0;

  while (true) {
    tries++;
    try {
      const kqlQuery = `customMetrics | where name == 'LoginLink'`;
      const response = await monitorQueryClient.queryWorkspace(appId, kqlQuery, { timespan: "P1D" });
      if (response.tables[0].rows.length > 0) {
        console.log('Metric is available.');
        break;
      } else {
        console.log('Metric not available yet, retrying in 5 seconds...');
        if ( (tries % 5) == 0 ) {
          console.log('5 checks without metric. Resending it...');
          client.trackMetric({
            name: "LoginLink",
            value: 1,
            properties: { url: loginLinkUrl }  // Additional data
          });
        } else if ( tries > MAX_TRIES ) {
          console.error(`Exceeded ${MAX_TRIES} checks and no metric. Quitting...`);
          code = 1;
          break;
        }
        await delay(5000);
      }
    } catch (error) {
      console.error('Error querying Application Insights:', error);
      tries += 30; // penalize an error try
      await delay(5000); // Retry after delay even in case of error
    }
  }

  console.log('Exiting...');
  process.exit(code);
}

// Call the function
checkMetricAvailability();
INNER_EOF

# Run the Node.js script
node app.js || (echo "Node had an error" >&2 && exit 1)

# End of the inner script
EOF
# End of the outer heredoc. Exit with the exit status of the heredoc bash script

exit $?

