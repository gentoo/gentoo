# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Copy-on-write B-tree data structure"
HOMEPAGE="http://liw.fi/larch/"
SRC_URI="http://code.liw.fi/debian/pool/main/p/python-${PN}/python-${PN}_${PV}.orig.tar.gz"
#RESTRICT="test"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-python/CoverageTestRunner dev-util/cmdtest )"

RDEPEND="${PYTHON_DEPS}
	dev-python/cliapp
	dev-python/tracing
	dev-python/ttystatus"

src_test() {
	addwrite /proc/self/comm
	distutils-r1_src_test
}

python_test() {
	emake check
}
