# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils fdo-mime gnome2-utils

MY_P=${P/tex/TeX}-src

DESCRIPTION="Wysiwyg text processor with high-quality maths"
HOMEPAGE="http://www.texmacs.org/"
SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/tmftp/source/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="imlib jpeg netpbm qt4 svg spell"
KEYWORDS="~alpha amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux"

RDEPEND="
	app-text/ghostscript-gpl
	dev-scheme/guile:12[deprecated]
	media-libs/freetype
	x11-apps/xmodmap
	x11-libs/libXext
	virtual/latex-base
	imlib? ( media-libs/imlib2 )
	jpeg? ( || ( media-gfx/imagemagick media-gfx/jpeg2ps ) )
	netpbm? ( media-libs/netpbm )
	qt4? ( dev-qt/qtgui:4 )
	spell? ( app-text/aspell )
	svg? ( || ( media-gfx/inkscape gnome-base/librsvg:2 ) )
"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# respect LDFLAGS, bug #338459
	epatch "${FILESDIR}"/${PN}-plugins-1.patch

	# dont update mime and desktop databases and icon cache
	epatch "${FILESDIR}"/${PN}-updates.patch

	eautoreconf
}

src_configure() {
	econf \
		--enable-optimize="${CXXFLAGS}" \
		$(use_with imlib imlib2) \
		$(use_enable qt4 qt)
}

src_install() {
	default
	domenu "${FILESDIR}"/TeXmacs.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
