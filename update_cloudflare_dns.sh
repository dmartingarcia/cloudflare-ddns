#!/bin/bash

#   Configuration
cloudflare_dns_token="$CLOUDFLARE_API_KEY"
cloudflare_zone_id="$1"
cloudflare_record_id="$2"
cloudflare_record_alias="$3"
logdest="/tmp/cloudflare-ip-$3.log"

# Get current external IP
external_ip=$(curl -s "https://api.ipify.org")

# Get Cloudflare DNS IP for ***
fetched_dns_data=$(curl -s -X GET \
--url https://api.cloudflare.com/client/v4/zones/${cloudflare_zone_id}/dns_records/${cloudflare_record_id} \
-H "Content-Type: application/json" \
-H "Authorization: Bearer ${cloudflare_dns_token}")

# Parse IP from JSON responce
cloudflare_ip=$(echo $fetched_dns_data | cut -d ":" -f 8 | tr -d '"' | cut -d "," -f 1)

# Log current IP info
echo "$(date '+%Y-%m-%d %H:%M:%S') - Current External IP is $external_ip, Cloudflare DNS IP for *** is $cloudflare_ip"

# Update DNS if IP has changed
if [ "$cloudflare_ip" != "$external_ip" ] && [ -n "$external_ip" ]; then
  curl -s -X PUT \
  --url "https://api.cloudflare.com/client/v4/zones/${cloudflare_zone_id}/dns_records/${cloudflare_record_id}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${cloudflare_dns_token}" \
  -d '{
    "content": "'"${external_ip}"'",
    "name": "@",
    "proxied": false,
    "type": "A",
    "comment": "root",
    "ttl": 1
      }'
  echo "Changed - ${cloudflare_record_alias} - IP from ${cloudflare_ip} to ${external_ip}" | tee -a "$logdest"
else
  echo "Not Changed - IP on ${cloudflare_record_alias}: ${cloudflare_ip}" | tee -a "$logdest"
fi
