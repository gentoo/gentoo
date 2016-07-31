# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools fdo-mime gnome2-utils qmake-utils

MY_P=${P/tex/TeX}-src

DESCRIPTION="Wysiwyg text processor with high-quality maths"
HOMEPAGE="http://www.texmacs.org/"
SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/tmftp/source/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="imlib jpeg netpbm pdf svg spell"
KEYWORDS="~alpha ~amd64 ~ppc ~x86 ~x86-interix ~amd64-linux ~x86-linux"

RDEPEND="
	app-text/ghostscript-gpl
	dev-scheme/guile:12[deprecated]
	media-libs/freetype
	x11-apps/xmodmap
	x11-libs/libXext
	virtual/latex-base
	dev-qt/qtgui:4
	imlib? ( media-libs/imlib2 )
	jpeg? ( || ( media-gfx/imagemagick media-gfx/jpeg2ps ) )
	netpbm? ( media-libs/netpbm )
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

	"${FILESDIR}"/${PN}-1.99.2-desktop.patch

	# remove new/delete declarations, bug 590002
	"${FILESDIR}"/${PN}-1.99-remove-new-declaration.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf

	# delete files that contain binary
	# headers only used on OS X
	rm src/{Plugins/Ghostscript/._ghostscript.cpp,System/Misc/._sys_utils.cpp} || die
}

src_configure() {
	econf \
		--enable-optimize="${CXXFLAGS}" \
		--with-qt="$(qt4_get_bindir)" \
		$(use_with imlib imlib2) \
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
