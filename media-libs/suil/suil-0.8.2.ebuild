# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils

DESCRIPTION="Lightweight C library for loading and wrapping LV2 plugin UIs"
HOMEPAGE="http://drobilla.net/software/suil/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk qt4"

RDEPEND="media-libs/lv2
	gtk? ( x11-libs/gtk+:2 )
	qt4? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( "AUTHORS" "NEWS" "README" )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
}

src_configure() {
	waf-utils_src_configure \
		"--mandir=${EPREFIX}/usr/share/man" \
		"--docdir=${EPREFIX}/usr/share/doc/${PF}" \
		$(use gtk || echo "--no-gtk") \
		$(use qt4 || echo "--no-qt") \
		$(use doc && echo "--docs")
}
