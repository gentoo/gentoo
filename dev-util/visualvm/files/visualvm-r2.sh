#!/bin/sh

# source the configuration file
. /etc/visualvm/visualvm.conf

# launch visualvm
exec sh /usr/share/visualvm/platform/lib/nbexec \
	--branding visualvm \
	--jdkhome "${visualvm_jdkhome}" \
	--userdir "${visualvm_default_userdir}" \
	--cachedir "${visualvm_default_cachedir}" \
	--clusters /usr/share/visualvm/cluster:/usr/share/visualvm/harness:/usr/share/visualvm/platform \
	${visualvm_default_options} "${@}"
