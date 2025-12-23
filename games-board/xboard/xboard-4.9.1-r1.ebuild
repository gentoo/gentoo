# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic xdg

DESCRIPTION="GUI for gnuchess and for internet chess servers"
HOMEPAGE="https://www.gnu.org/software/xboard/"
SRC_URI="mirror://gnu/xboard/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="+default-font gtk nls Xaw3d zippy"
RESTRICT="test" #124112

BDEPEND="
	virtual/pkgconfig
	x11-base/xorg-proto
	nls? ( sys-devel/gettext )
"
DEPEND="
	dev-libs/glib:2
	gnome-base/librsvg:2
	virtual/libintl
	x11-libs/cairo[X]
	x11-libs/libXpm
	default-font? (
		media-fonts/font-adobe-100dpi[nls?]
		media-fonts/font-misc-misc[nls?]
	)
	!gtk? (
		x11-libs/libX11
		x11-libs/libXt
		x11-libs/libXmu
		Xaw3d? ( x11-libs/libXaw3d )
		!Xaw3d? ( x11-libs/libXaw )
	)
	gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.0-gettext.patch
	"${FILESDIR}"/${PN}-4.8.0-gnuchess-default.patch
	"${FILESDIR}"/${PN}-4.9.1-gcc-10.patch
	"${FILESDIR}"/${PN}-4.9.1-type-of-handler.patch
)

DOCS=( AUTHORS COPYRIGHT ChangeLog FAQ.html NEWS README TODO ics-parsing.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #858617
	filter-lto

	local myeconfargs=(
		--disable-update-mimedb
		--datadir="${EPREFIX}"/usr/share
		$(use_enable nls)
		$(use_enable zippy)
		--disable-update-mimedb
		$(use_with gtk)
		$(use_with Xaw3d)
		$(usex gtk "--without-Xaw" $(use_with !Xaw3d Xaw))
		--with-gamedatadir="${EPREFIX}"/usr/share/games/${PN}
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use zippy && dodoc zippy.README
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "No chess engines are emerged by default! If you want a chess engine"
	elog "to play with, you can emerge gnuchess or crafty."
	elog "Read xboard FAQ for information."
	if ! use default-font ; then
		ewarn "Read the xboard(6) man page for specifying the font for xboard to use."
	fi
}
