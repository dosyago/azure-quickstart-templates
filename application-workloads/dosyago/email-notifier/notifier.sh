#!/bin/bash

region="$1"
resourceId="$2"

# Function to get access token from IMDS
getAuthToken() {
  accessToken=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://monitor.azure.com' -H Metadata:true -s | jq -r '.access_token')
  echo $accessToken
}

# Function to send custom metric
sendMetric() {
  local accessToken=$(getAuthToken)
  local currentTime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  local metricData='{
    "time": "'$currentTime'",
    "data": {
      "baseData": {
        "metric": "Memory Bytes in Use",
        "namespace": "Memory Profile",
        "dimNames": [
          "Process"
        ],
        "series": [
          {
            "dimValues": [
              "ContosoApp.exe"
            ],
            "min": 10,
            "max": 89,
            "sum": 190,
            "count": 4
          },
          {
            "dimValues": [
              "SalesApp.exe"
            ],
            "min": 10,
            "max": 23,
            "sum": 86,
            "count": 4
          }
        ]
      }
    }
  }'

  # Replace <region> and <resourceId> with actual values
  curl -X POST "https://${region}.monitoring.azure.com${resourceId}/metrics" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $accessToken" \
    -d "$metricData"
}

# Send the metric
sendMetric

