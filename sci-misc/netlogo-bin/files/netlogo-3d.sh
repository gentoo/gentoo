#!/bin/bash
NETLOGO_INSTALL_PATH="/usr/share/netlogo-bin"
cd ${NETLOGO_INSTALL_PATH}
java -classpath $(java-config -p netlogo-bin) -Dorg.nlogo.is3d=true -jar NetLogo.jar
