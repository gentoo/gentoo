# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE='threads(+)'

inherit flag-o-matic python-any-r1 waf-utils

DESCRIPTION="Lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="http://drobilla.net/software/suil/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc gtk qt5"

BDEPEND="
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
CDEPEND="
	>=media-libs/lv2-1.16.0
	gtk? ( x11-libs/gtk+:2 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
	)"
RDEPEND="${CDEPEND}"
DEPEND="
	${CDEPEND}
	${PYTHON_DEPS}
"

DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	default
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
}

src_configure() {
	waf-utils_src_configure \
		--mandir="${EPREFIX}/usr/share/man" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--no-qt4 \
		$(usex gtk '' --no-gtk) \
		$(usex qt5 '' --no-qt5) \
		$(usex doc --docs '')
}
