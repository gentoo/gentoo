# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
MY_PV=V_${PV//./_}

inherit distutils-r1 fdo-mime

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://edyoung.github.io/gnofract4d/"
SRC_URI="https://github.com/edyoung/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+help"

RDEPEND="x11-libs/gtk+:2
	media-libs/libpng:0=
	virtual/jpeg:0
	>=dev-python/pygtk-2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	help? (	app-text/rarian
		dev-libs/libxslt )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.14-desktop.patch
	"${FILESDIR}"/${P}-xsl.patch
)

S="${WORKDIR}"/${PN}-${MY_PV}

python_compile_all() {
	if use help; then
		ln -s "${BUILD_DIR}"/lib/fract4d/fract4dc.so fract4d/ || die
		"${EPYTHON}" createdocs.py || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	rm -rf "${ED%/}"/usr/share/doc/${PN} || die
	if ! use help; then
		rm -rf "${ED%/}"/usr/share/gnome/help/${PN} || die
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
