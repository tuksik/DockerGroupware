#!/bin/bash

#Anpassen der Konfiguration
envsubst < /srv/scripts/ipfailover.py.tmpl > /srv/scripts/ipfailover.py

echo "Starting Failover script"
python /srv/scripts/ipfailover.py
