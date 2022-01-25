#!/usr/bin/env bash
set -eu

# Check if ghost domain and api key as been set
if [ -z "${INPUT_GHOST_DOMAIN}" ]; then
  echo "Unable to find the domain. Did you set with.domain?"
  exit 1
fi

if [ -z "${INPUT_GHOST_API_KEY}" ]; then
  echo "Unable to find the api key. Did you set with.api_key"
  exit 1
fi

if [ -z "${INPUT_FILE}" ]; then
  echo "Unable to find the file. Did you set with.file"
  exit 1
fi

# Admin API key goes here
KEY="${INPUT_GHOST_API_KEY}"

# Split the key into ID and SECRET
TMPIFS=$IFS
IFS=':' read ID SECRET <<< "$KEY"
IFS=$TMPIFS

# Prepare header and payload
NOW=$(date +'%s')
FIVE_MINS=$(($NOW + 300))
HEADER="{\"alg\": \"HS256\",\"typ\": \"JWT\", \"kid\": \"$ID\"}"
PAYLOAD="{\"iat\":$NOW,\"exp\":$FIVE_MINS,\"aud\": \"/v3/admin/\"}"

# Helper function for perfoming base64 URL encoding
base64_url_encode() {
    declare input=${1:-$(</dev/stdin)}
    # Use `tr` to URL encode the output from base64.
    printf '%s' "${input}" | base64 | tr -d '=' | tr '+' '-' |  tr '/' '_'
}

# Prepare the token body
header_base64=$(base64_url_encode "$HEADER")
payload_base64=$(base64_url_encode "$PAYLOAD")

header_payload="${header_base64}.${payload_base64}"

# Create the signature
signature=$(printf '%s' "${header_payload}" | openssl dgst -binary -sha256 -mac HMAC -macopt hexkey:$SECRET | base64_url_encode)

# Concat payload and signature into a valid JWT token
TOKEN="${header_payload}.${signature}"


curl -X POST -v -F "file=@${INPUT_FILE}" -H "Authorization: Ghost $TOKEN" ${INPUT_GHOST_DOMAIN}/ghost/api/v3/admin/themes/upload