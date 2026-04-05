# Netcup DynDNS Updater

Dockerized dynamic DNS updater for netcup DNS API. Automatically updates your DNS records when your IP changes.

## Quick Start

```bash
docker run -d \
  -e OWNDYNDNS_USERNAME=<username> \
  -e OWNDYNDNS_PASSWORD=<password> \
  -e NETCUP_APIKEY=<apikey> \
  -e NETCUP_APIPASSWORD=<apipassword> \
  -e NETCUP_CUSTOMERID=<customerid> \
  -p 80:80 \
  ghcr.io/mcdax/netcup_ddns_updater:latest
```

Or use docker-compose:

```bash
curl -O https://raw.githubusercontent.com/mcdax/netcup_ddns_updater/master/docker-compose.yml.sample
cp docker-compose.yml.sample docker-compose.yml
# Edit environment variables
docker-compose up -d
```

## API

Update DNS records via HTTP request:

```
https://<your-domain>/update.php?user=<username>&password=<pass>&ipv4=<ipaddr>&ipv6=<ip6addr>&domain=<domain>
```

Parameters:
- `user` - Username (from OWNDYNDNS_USERNAME)
- `password` - Password (from OWNDYNDNS_PASSWORD)
- `ipv4` - IPv4 address
- `ipv6` - IPv6 address (optional)
- `domain` - Domain/hostname to update (comma-separated for multiple)

## FritzBox Setup

1. Go to **Internet** → **Freigaben** → **DynDNS**
2. Select **Benutzerdefiniert**
3. Enter Update-URL:
   ```
   https://<your-domain>/update.php?user=<username>&password=<pass>&ipv4=<ipaddr>&ipv6=<ip6addr>&domain=<domain>
   ```
4. Domainname: `<your-domain>` (comma-separated for multiple domains)
5. Username: `<username from OWNDYNDNS_USERNAME>`
6. Password: `<password from OWNDYNDNS_PASSWORD>`

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `OWNDYNDNS_USERNAME` | Yes | Username for router authentication |
| `OWNDYNDNS_PASSWORD` | Yes | Password for router authentication |
| `NETCUP_APIKEY` | Yes | netcup API key (from CCP) |
| `NETCUP_APIPASSWORD` | Yes | netcup API password (from CCP) |
| `NETCUP_CUSTOMERID` | Yes | netcup customer ID |
| `DEBUG` | No | Enable debug mode (default: false) |

## Prerequisites

- Create DNS records in netcup CCP before using
- API credentials from netcup CCP (https://ccp.netcup.net)

## License

GNU General Public License v3.0
