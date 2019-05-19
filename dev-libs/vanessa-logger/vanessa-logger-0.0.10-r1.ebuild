# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Generic logging layer that to log to syslog, an open file handle or a file name"
HOMEPAGE="http://horms.net/projects/vanessa/"
SRC_URI="http://horms.net/projects/vanessa/download/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${MY_P}"
DOCS="AUTHORS NEWS README TODO sample/*.c sample/*.h"
