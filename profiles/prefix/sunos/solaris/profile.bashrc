# Copyright 1999-2012 Gentoo Foundation; Distributed under the GPL v2
# $Id$

# Automatically determine whether or not gen_usr_ldscript should be
# doing something or not.  This is necessary due to previous screwups,
# which may have lead to people bootstrapping already without
# gen_usr_ldscript being active, while existing installs should remain
# untouched for now.
if [[ -z ${PREFIX_DISABLE_GEN_USR_LDSCRIPT} ]] ; then
	[[ ! -e ${EPREFIX}/lib/libz.so.1 ]] \
		&& PREFIX_DISABLE_GEN_USR_LDSCRIPT=yes
fi
