# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base waf-utils

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
	# otherwise automagic
	use gtk || sed -i -e 's/gtk+-2.0/DiSaBlEd/' wscript
	use qt4 || sed -i -e 's/QtGui/DiSaBlEd/' wscript
	waf-utils_src_configure \
		"--mandir=${EPREFIX}/usr/share/man" \
		"--docdir=${EPREFIX}/usr/share/doc/${PF}" \
		$(use doc && echo "--docs")
}
