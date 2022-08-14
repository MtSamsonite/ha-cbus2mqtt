FROM mtsamsonite/cbus2mqtt-$BUILD_ARCH


# Runs cmqttd itself
CMD /entrypoint-cmqttd.sh
