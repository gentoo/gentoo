# Copyright 1999-2016 Gentoo Foundation
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
IUSE="imlib jpeg netpbm pdf qt4 svg spell"
KEYWORDS="alpha amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux"

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

PATCHES=(
	# respect LDFLAGS, bug #338459
	"${FILESDIR}"/${PN}-plugins-1.patch

	# dont update mime and desktop databases and icon cache
	"${FILESDIR}"/${PN}-updates.patch

	# underlinking 540600
	"${FILESDIR}"/${P}-underlinking.patch

	# scanelf: rpath_security_checks(): Security problem NULL DT_RUNPATH
	"${FILESDIR}"/${P}-norpath.patch

	"${FILESDIR}"/${P}-desktop.patch

	# remove new/delete declarations, bug 590002
	"${FILESDIR}"/${PN}-1.99-remove-new-declaration.patch
)

src_prepare() {
	epatch ${PATCHES[@]}

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-optimize="${CXXFLAGS}" \
		$(use_with imlib imlib2) \
		$(use_enable qt4 qt) \
		$(use_enable pdf pdf-renderer)
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
