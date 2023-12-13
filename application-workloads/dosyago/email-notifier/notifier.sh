#!/bin/bash

region="${1//[[:space:]]/}"
resourceId="${2//[[:space:]]/}"
nodo="$3"


echo "Region: [$region]"
echo "ResourceID: [$resourceId]"

command -v jq || sudo apt install -y jq

# Function to get access token from Azure AD
getAuthToken() {
  accessToken=$(curl 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-01-01&resource=https://management.azure.com/' -H Metadata:true -s | jq -r '.access_token')
  echo $accessToken
}

# Function to send custom metric
sendMetric() {
  local accessToken=$(getAuthToken)
  local currentTime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Construct the metric data JSON
  local metricData='{
    "time": "'$currentTime'",
    "data": {
      "baseData": {
        "metric": "CustomMetric",
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

  # Azure Monitor Management API endpoint
  local apiEndpoint="https://management.azure.com/${resourceId}/providers/microsoft.insights/metrics?api-version=2021-01-01"

  # Send the metric data
  curl -X POST "$apiEndpoint" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $accessToken" \
    -d "$metricData"
}

# Send the metric
sendMetric

if [[ -z "$nodo" ]]; then
  nohup bash -c "$(cat <<EOF
    sleep 15
    $0 $region $resourceId nodo
EOF
  )" &>/dev/null
fi

exit 0

