# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="Twisted Runner is a process management library and inetd replacement"

KEYWORDS="~alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="
	=dev-python/twisted-core-${TWISTED_RELEASE}*[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	!dev-python/twisted
"
