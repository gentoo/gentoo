# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

if [[ ${EBUILD_PHASE} == setup ]] ; then
	if [[ ${CATEGORY}/${PN} == sys-devel/flex ]] ; then
		# Solaris 10's <stdbool.h> requires the C99 standard
		[[ " ${CFLAGS} "   == *" -std=c99 "* ]] || CFLAGS="-std=c99 ${CFLAGS}"
		[[ " ${CXXFLAGS} " == *" -std=c99 "* ]] || CXXFLAGS="-std=c99 ${CXXFLAGS}"
	fi
fi
