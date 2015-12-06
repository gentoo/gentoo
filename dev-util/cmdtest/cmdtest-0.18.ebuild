# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="black box tests Unix command line tools"
HOMEPAGE="http://liw.fi/cmdtest/"
SRC_URI="http://code.liw.fi/debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="
	${PYTHON_DEPS}
	dev-python/cliapp[${PYTHON_USEDEP}]
	dev-python/ttystatus[${PYTHON_USEDEP}]
"

src_compile() {
	addwrite /proc/self/comm
	distutils-r1_src_compile
}
