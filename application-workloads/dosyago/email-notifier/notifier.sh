#!/bin/bash

appInsightsKey="$1"

# Run sendMetric in background after a delay using nohup
nohup bash -c '
  # Function to send data to Application Insights
  sendMetric() {
    local message="The time is now $(date)"
    curl -X POST -H "Content-Type: application/json" -d "{
      \"data\": {
        \"baseData\": {
          \"metric\": {
            \"name\": \"CustomMetric\",
            \"value\": 1,
            \"properties\": {
              \"message\": \"'"$message"'\"
            }
          }
        }
      }
    }" "https://dc.services.visualstudio.com/v2/track" -H "x-api-key: '"$appInsightsKey"'"
  }

  sendMetric

  # Wait for 15 seconds
  sleep 15

  # Send the metric
  sendMetric
' &> /dev/null &

# Exit script immediately with status 0
exit 0

