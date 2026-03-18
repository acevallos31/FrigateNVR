param(
  [string]$BrokerHost = "192.168.1.141",
  [int]$BrokerPort = 1883,
  [string]$Topic = "frigate/tracked_object_update",
  [string]$Camera = "entrada_principal",
  [string]$EventId = "test-moto-001"
)

$payload = @{
  id = $EventId
  type = "motorcycle"
  name = "unknown"
  score = 0.91
  camera = $Camera
  timestamp = [int][double]::Parse((Get-Date -UFormat %s))
} | ConvertTo-Json -Compress

mosquitto_pub -h $BrokerHost -p $BrokerPort -t $Topic -m $payload
