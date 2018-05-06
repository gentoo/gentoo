# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools xdg-utils gnome2-utils qmake-utils

MY_P=${P/tex/TeX}-src

DESCRIPTION="Wysiwyg text processor with high-quality maths"
HOMEPAGE="http://www.texmacs.org/"
SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/tmftp/source/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="imlib jpeg netpbm pdf svg spell"
KEYWORDS="~alpha ~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-text/ghostscript-gpl
	<dev-scheme/guile-1.9[deprecated]
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
	x11-base/xorg-proto"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# respect LDFLAGS, bug #338459
	"${FILESDIR}"/${PN}-plugins-1.patch

	# dont update mime and desktop databases and icon cache
	"${FILESDIR}"/${PN}-updates.patch

	"${FILESDIR}"/${PN}-1.99.2-desktop.patch

	# remove new/delete declarations, bug 590002
	"${FILESDIR}"/${PN}-1.99-remove-new-declaration.patch

	"${FILESDIR}"/${PN}-1.99.6-math_util.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	econf \
		--enable-optimize="${CXXFLAGS}" \
		--with-qt="$(qt4_get_bindir)" \
		$(use_with imlib imlib2) \
		$(use_enable pdf pdf-renderer)
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
