# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER=3.0-gtk3
PYTHON_COMPAT=( python3_{7,8,9} )

inherit autotools desktop python-single-r1 wxwidgets xdg-utils

DESCRIPTION="simulator for Conway's Game of Life and other cellular automata"
HOMEPAGE="http://golly.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="tiff"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="virtual/opengl
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,tiff?]
	${PYTHON_DEPS}
"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-src

PATCHES=(
	"${FILESDIR}"/${PN}-3.3-nondynamic-python.patch
	"${FILESDIR}"/${PN}-3.3-allow-py23-exec.patch
	"${FILESDIR}"/${PN}-3.3-glife-py23.patch
	"${FILESDIR}"/${PN}-3.3-allow-py3.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
	setup-wxwidgets
}

src_prepare() {
	default

	# patches change configure.ac and Makefile.am
	pushd gui-wx/configure
		eautoreconf
	popd
}

src_configure() {
	ECONF_SOURCE=gui-wx/configure econf \
		--with-wxshared
}

src_install() {
	emake docdir= DESTDIR="${D}" install
	dodoc docs/ReadMe.html
	newicon --size 32 gui-wx/icons/appicon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Golly" ${PN} "Science"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
