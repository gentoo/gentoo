# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# never use /bin/sh as CONFIG_SHELL on AIX: it is ways too slow,
# as well as broken in some corner cases.
export CONFIG_SHELL=${BASH}

if [[ ${EBUILD_PHASE} == setup ]] ; then
	if [[ ${CATEGORY}/${P} == app-arch/tar-1.29* ]] ; then
		# for distinct EEXIST and ENOTEMPTY,
		# https://savannah.gnu.org/patch/?9284
		[[ " ${CPPFLAGS} "   == *" -D_LINUX_SOURCE_COMPAT "* ]] || CPPFLAGS="-D_LINUX_SOURCE_COMPAT ${CPPFLAGS}"
	fi
fi
