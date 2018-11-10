# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A function plotter program written in PyGTK"
HOMEPAGE="http://lybniz2.sourceforge.net/"
SRC_URI="mirror://sourceforge/lybniz2/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk:2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's/Education;/Education;Math;/' \
		${PN}.desktop || die

	distutils-r1_src_prepare
}
