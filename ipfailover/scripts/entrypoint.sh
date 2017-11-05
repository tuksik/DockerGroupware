#!/bin/bash

#Anpassen der Konfiguration
envsubst < /srv/scripts/ipfailover.py.tmpl > /srv/scripts/ipfailover.py

echo "Starting Failover script"
while true; do
	python /srv/scripts/ipfailover.py
	sleep 2
done
