#!/bin/bash

# source the configuration file
source /etc/visualvm/visualvm.conf

# if visualvm userdir does not exist, create it and put in the default module configuration
# so that user does not face warning that some (unneeded) modules were not found
if [ ! -e "${visualvm_default_userdir}" ] ; then
	mkdir -p "${visualvm_default_userdir}/config/Modules"
	cp /usr/share/visualvm/config/* "${visualvm_default_userdir}/config/Modules/"
fi

# launch visualvm
/usr/share/netbeans-platform-8.0/lib/nbexec --jdkhome ${visualvm_jdkhome} --userdir ${visualvm_default_userdir} \
	--branding visualvm --clusters /usr/share/visualvm/cluster:/usr/share/netbeans-platform-8.0:/usr/share/netbeans-profiler-8.0 \
	${visualvm_default_options}
