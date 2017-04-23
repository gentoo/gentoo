# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="xml"

inherit eutils python-single-r1

DESCRIPTION="TreeLine is a structured information storage program"
HOMEPAGE="http://treeline.bellz.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

DEPEND="
	${PYTHON_DEPS}
"
RDEPEND="
	${DEPEND}
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/TreeLine"

src_prepare() {
	rm doc/LICENSE || die

	python_export PYTHON_SITEDIR
	sed -i "s;prefixDir, 'lib;'${PYTHON_SITEDIR};" install.py || die
}

src_install() {
	"${EPYTHON}" install.py -x -p /usr/ -d /usr/share/doc/${PF} -b "${D}" || die
}
