# server-healthcheck

A dependency-free bash script + systemd timer that checks disk and memory usage every 5 minutes and posts a webhook alert (Slack/Discord-compatible `{"text": "..."}` payload) when either crosses 90%.

## Install

```bash
sudo cp healthcheck.sh /usr/local/bin/healthcheck.sh
sudo chmod +x /usr/local/bin/healthcheck.sh

echo 'HEALTHCHECK_WEBHOOK_URL=https://hooks.slack.com/services/...' | sudo tee /etc/healthcheck.env

sudo cp healthcheck.service healthcheck.timer /etc/systemd/system/
sudo systemctl enable --now healthcheck.timer
```

## Why systemd timers over cron

Timers get proper logging via `journalctl -u healthcheck.service`, and `OnBootSec`/`OnUnitActiveSec` behave predictably across reboots without the quirks of `@reboot` cron entries.
