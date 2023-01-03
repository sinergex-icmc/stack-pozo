 SELECT device_up.received_at AS "time",
    (rx_info.value ->> 'rssi'::text)::smallint AS rssi,
    round((rx_info.value ->> 'loRaSNR'::text)::numeric, 1) AS snr,
    encode(decode(rx_info.value ->> 'gatewayID'::text, 'base64'::text), 'hex'::text) AS gatewayid,
    device_up.dr,
    device_up.frequency,
    encode(device_up.dev_eui, 'hex'::text) AS deveui,
    device_up.device_name AS name,
    (device_up.object -> 'battery'::text)::numeric(3,0) AS bateria,
    (device_up.object -> 'distance'::text)::numeric(4,0) AS distance
   FROM device_up,
    LATERAL jsonb_array_elements(device_up.rx_info) rx_info(value)
  WHERE device_up.application_name::text = 'SNGX-Niveles'::text AND device_up.device_name::text = 'SondaPozo'::text;
