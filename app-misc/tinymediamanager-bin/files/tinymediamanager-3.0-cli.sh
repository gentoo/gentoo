#!/bin/bash
[ ! -d "${HOME}"/.tmm ] && mkdir "${HOME}"/.tmm
cd "${HOME}"/.tmm
java \
	-Djava.net.preferIPv4Stack=true \
	-Dappbase=http://www.tinymediamanager.org/ \
	-Djna.nosys=true \
	-Djava.awt.headless=true \
	-Dtmm.contentfolder="${HOME}"/.tmm \
	-Xms64m \
	-Xmx512m \
	-Xss512k \
	-cp /opt/tinyMediaManager/tmm.jar:/opt/tinyMediaManager/lib/*:/opt/tinyMediaManager/plugins/* \
	org.tinymediamanager.TinyMediaManager \
	"$@"
