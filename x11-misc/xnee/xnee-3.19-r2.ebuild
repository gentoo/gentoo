# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic virtualx

DESCRIPTION="Program suite to record, replay and distribute user actions"
HOMEPAGE="https://xnee.wordpress.com/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome xosd"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libxcb
	gnome? (
		>=gnome-base/gconf-2
		x11-libs/gtk+:2
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	gnome? ( virtual/imagemagick-tools[jpeg,png] )
"

# This needs RECORD extension from X.org server which isn't necessarily
# enabled. Xlib: extension "RECORD" missing on display ":0.0".
RESTRICT="test"

DOCS=( AUTHORS BUGS ChangeLog FAQ NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-3.18-linker.patch
	"${FILESDIR}"/${P}-libgnomeui-only-for-applets.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -fcommon
	econf \
		$(use_enable gnome gui) \
		$(use_enable xosd buffer_verbose) \
		$(use_enable xosd verbose) \
		$(use_enable xosd) \
		--disable-gnome-applet \
		--disable-static \
		--disable-static-programs \
		--enable-cli \
		--enable-lib
}

src_test() {
	virtx emake check
}

src_install() {
	default
	use gnome && make_desktop_entry gnee Gnee ${PN} "Utility;GTK"
	find "${ED}" -name '*.la' -delete || die
}
