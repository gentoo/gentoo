#!/bin/bash
NETLOGO_INSTALL_PATH="/usr/share/netlogo-bin"
cd ${NETLOGO_INSTALL_PATH}
java -classpath $(java-config -p netlogo-bin) -jar NetLogo.jar
