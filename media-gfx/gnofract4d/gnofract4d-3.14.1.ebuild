# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
MY_PV=V_${PV//./_}

inherit distutils-r1 xdg-utils

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://edyoung.github.io/gnofract4d/"
SRC_URI="https://github.com/edyoung/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	media-libs/libpng:0=
	virtual/jpeg:0
	>=dev-python/pygtk-2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/gnofract4d-3.14-desktop.patch
	"${FILESDIR}"/gnofract4d-3.14-manual.patch
)

S="${WORKDIR}"/${PN}-${MY_PV}

python_compile_all() {
	# Needs fixing to be able to generate commands.xml
	"${EPYTHON}" createdocs.py || die
}

python_install_all() {
	distutils-r1_python_install_all
	rm -rf "${ED%/}"/usr/share/doc/${PN} || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
