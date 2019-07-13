# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads"

inherit distutils-r1

DESCRIPTION="Generate test data for backup software testing."
HOMEPAGE="https://liw.fi/genbackupdata/"
#SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/$PN/snapshot/${P}.tar.gz"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/cliapp[${PYTHON_USEDEP}]
	>=dev-python/ttystatus-0.31[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}"

src_compile() {
	addwrite /proc/self/comm
	distutils-r1_src_compile
	emake genbackupdata.1
}
