# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Gnome front-end for file management on iRiver iFP MP3 players"
HOMEPAGE="http://ifp-gnome.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/libgnome-python-2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2[${PYTHON_USEDEP}]
	>=dev-python/pyifp-0.2.2[${PYTHON_USEDEP}]"
DEPEND=""

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-file-locations.patch
)

src_compile() {
	python_fix_shebang ${PN}.py
}

src_install() {
	insinto /usr/share/${PN}
	doins ${PN}.{glade,png}
	newbin ${PN}.py ${PN}
}
