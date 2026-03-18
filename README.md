# FrigateNVR

n8n workflows for Frigate event alerts, anti-spam filtering, WhatsApp delivery through WAHA, and WhatsApp ack tracking in PostgreSQL.

## Repository contents

- `workflows/frigate-alerts.json`: main workflow for MQTT -> Frigate -> anti-spam -> WAHA -> PostgreSQL
- `workflows/waha-acks-webhook.json`: webhook workflow for WAHA ack events -> PostgreSQL
- `sql/001_extend_frigate_events.sql`: schema extension for WhatsApp tracking fields
- `examples/test-motorcycle-event.ps1`: PowerShell test event for MQTT
- `docs/waha-webhooks.md`: WAHA webhook configuration notes

## Database

This project expects PostgreSQL database `casaos` and table `public.frigate_events`.

Apply the SQL migration before importing the workflows:

```sql
\i sql/001_extend_frigate_events.sql
```

## Import in n8n

Import both workflows:

1. `workflows/frigate-alerts.json`
2. `workflows/waha-acks-webhook.json`

## Required placeholders

Replace these placeholders in the imported workflows:

- `YOUR_FRIGATE_DOMAIN`
- `YOUR_WAHA_DOMAIN`
- `YOUR_WAHA_API_KEY`
- `YOUR_GROUP_ID@g.us`

## Credentials in n8n

Configure credentials manually after import:

- MQTT credential for Frigate events
- PostgreSQL credential pointing to database `casaos`

## Main workflow behavior

The main workflow:

- reads `frigate/tracked_object_update` from MQTT
- normalizes Frigate payloads
- detects known people, motorcycles, vehicles, and suspicious vehicles
- prevents duplicate alerts within a short time window
- sends WhatsApp alerts to a group via WAHA
- stores send metadata in `public.frigate_events`

## WAHA webhook workflow

The webhook workflow updates WhatsApp status fields in PostgreSQL using `message.ack` and `message.ack.group` events.

Recommended WAHA webhook settings are documented in `docs/waha-webhooks.md`.

## Validation queries

```sql
SELECT
  event_id,
  camera,
  texto,
  whatsapp_chat_id,
  whatsapp_message_id,
  whatsapp_ack,
  whatsapp_status,
  whatsapp_sent_at,
  whatsapp_delivered_at,
  whatsapp_read_at,
  whatsapp_error
FROM public.frigate_events
ORDER BY id DESC
LIMIT 20;
```

## Local test

```powershell
./examples/test-motorcycle-event.ps1
```

## Security notes

This repository is sanitized for public sharing.

Do not commit:

- real WAHA API keys
- real n8n credentials exports
- private chat or group ids if you do not want them exposed
- internal-only domains or IP addresses

## Recommended activation order

1. Apply SQL migration.
2. Import workflows into n8n.
3. Set PostgreSQL and MQTT credentials.
4. Replace placeholders in the HTTP nodes and Frigate snapshot URL.
5. Configure WAHA webhook delivery.
6. Activate the webhook workflow first.
7. Activate the main Frigate workflow.
8. Publish a test motorcycle event.
