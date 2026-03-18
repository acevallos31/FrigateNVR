# WAHA Webhooks

This project uses a second n8n workflow to receive WAHA ack events and update `public.frigate_events` with queued, sent, delivered, and read states.

## Recommended WAHA environment variables

Set these variables in your WAHA container:

```env
WHATSAPP_HOOK_URL=https://YOUR_N8N_DOMAIN/webhook/waha-acks
WHATSAPP_HOOK_EVENTS=message.ack,message.ack.group
WHATSAPP_HOOK_HMAC_KEY=CHANGE_ME
```

If you do not want HMAC validation yet, omit `WHATSAPP_HOOK_HMAC_KEY`.

## Events used

The webhook workflow expects these WAHA events:

- `message.ack`
- `message.ack.group`

Relevant payload fields:

- `payload.id`: full WhatsApp message id, used to match `whatsapp_message_id`
- `payload.from`: chat id, for example `123456789@g.us`
- `payload.participant`: participant id for group ack updates
- `payload.ack`: integer ack code
- `payload.ackName`: string representation of the ack

## Ack mapping

- `-1` -> `failed`
- `0` -> `queued`
- `1` -> `sent`
- `2` -> `delivered`
- `3` -> `read`
- `4` -> `played`

## Validation query

```sql
SELECT
  event_id,
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
