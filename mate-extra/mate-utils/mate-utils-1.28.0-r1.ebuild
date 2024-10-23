# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="Utilities for the MATE desktop"
LICENSE="FDL-1.1+ GPL-2+ GPL-3+ LGPL-2+"
SLOT="0"

IUSE="X applet debug nls test udisks"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	>=dev-libs/glib-2.50:2
	>=gnome-base/libgtop-2.12:2=
	|| (
		media-libs/libcanberra-gtk3
		>=media-libs/libcanberra-0.4[gtk3(-)]
	)
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/pango
	applet? ( >=mate-base/mate-panel-1.28.0 )
	udisks? ( >=sys-fs/udisks-1.90.0:2 )
"

RDEPEND="${COMMON_DEPEND}
	>=mate-base/mate-desktop-$(ver_cut 1-2)
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	app-text/rarian
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-build/gtk-doc-am
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	# Make apps visible in all DEs.
	LC_ALL=C find . -iname '*.desktop.in*' -exec \
		sed -e '/OnlyShowIn/d' -i {} + || die

	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--enable-zlib \
		--enable-debug=$(usex debug yes minimum) \
		$(use_with X x) \
		$(use_enable applet gdict-applet) \
		$(use_enable nls) \
		$(use_enable udisks disk_image_mounter)
}
