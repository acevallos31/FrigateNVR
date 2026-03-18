ALTER TABLE public.frigate_events
ADD COLUMN IF NOT EXISTS whatsapp_chat_id text,
ADD COLUMN IF NOT EXISTS whatsapp_message_id text,
ADD COLUMN IF NOT EXISTS whatsapp_ack integer,
ADD COLUMN IF NOT EXISTS whatsapp_status text,
ADD COLUMN IF NOT EXISTS whatsapp_sent_at timestamp without time zone,
ADD COLUMN IF NOT EXISTS whatsapp_delivered_at timestamp without time zone,
ADD COLUMN IF NOT EXISTS whatsapp_read_at timestamp without time zone,
ADD COLUMN IF NOT EXISTS whatsapp_error text;

CREATE INDEX IF NOT EXISTS idx_frigate_events_whatsapp_message_id
ON public.frigate_events (whatsapp_message_id);

CREATE INDEX IF NOT EXISTS idx_frigate_events_whatsapp_status
ON public.frigate_events (whatsapp_status);
