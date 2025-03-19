# Cloudflare DDNS Updater

This project is a simple Dynamic DNS (DDNS) updater that synchronizes your external IP address with a Cloudflare DNS record. The provided script (`update_cloudflare_dns.sh`) fetches your current external IP and compares it with the IP on a specified Cloudflare DNS record. If they differ, it updates the DNS record via the Cloudflare API.

## Usage

The script requires the following:
- An environment variable `CLOUDFLARE_API_KEY` set to your Cloudflare API key.
- Command line parameters passed in the following order:
    1. Cloudflare Zone ID
    2. Cloudflare Record ID
    3. DNS Record Alias (e.g., `example.com`)

Example usage:
```
./update_cloudflare_dns.sh zoneid recordid example.com
```
## Scheduling Execution with Cron

You can automate the script by scheduling it with cron. For example, to run the updater every 5 minutes, add the following line to your crontab:

```
*/5 * * * * path/to/cloudflare-ddns/update_cloudflare_dns.sh <zone_id> <record_id> <record_alias>
```

Replace the script path and parameters with the correct values. Make sure the script is executable, and if your environment variable (CLOUDFLARE_API_KEY) is not set globally, include it within the crontab entry or within the script.

To edit your crontab, use:

```
crontab -e
```
## Configuration

Inside the script, the following variables are used:
- `cloudflare_dns_token`: Retrieved from the environment variable `CLOUDFLARE_API_KEY`.
- `cloudflare_zone_id`, `cloudflare_record_id`, `cloudflare_record_alias`: Provided as script parameters.

## Obtaining Cloudflare IDs and Alias

### Zone ID and Record ID
To obtain the required Zone ID and Record ID:
1. Log in to your Cloudflare account.
2. Go to your domain’s Overview page to find the Zone ID.
3. Navigate to the DNS settings to locate the specific record. You can click on the record for details and find the Record ID, or use the Cloudflare API.

### Using the Cloudflare API
You can list DNS records via the Cloudflare API to retrieve these IDs. Here is an example API call:
```
curl -X GET "https://api.cloudflare.com/client/v4/zones/<zone_id>/dns_records" \
         -H "Content-Type: application/json" \
         -H "Authorization: Bearer <CLOUDFLARE_API_KEY>"
```
Replace `<zone_id>` and `<CLOUDFLARE_API_KEY>` with your actual values.

## API Key Documentation

For details about generating and managing your Cloudflare API key, please refer to the [Cloudflare API documentation](https://developers.cloudflare.com/api).

## Notes

- Ensure that the `CLOUDFLARE_API_KEY` environment variable is properly set before running the script.
- The script logs changes to a file located at `/tmp/cloudflare-ip-<alias>.log` where `<alias>` is the supplied alias parameter.
- The script uses the Cloudflare API to update the DNS record if the detected external IP differs from the current record value.

Happy coding!