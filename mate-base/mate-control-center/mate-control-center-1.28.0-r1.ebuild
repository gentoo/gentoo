# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="The MATE Desktop configuration tool"
LICENSE="FDL-1.1+ GPL-2+ LGPL-2+ LGPL-2.1+ HPND"
SLOT="0"

IUSE="accountsservice debug nls systemd"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	>=dev-libs/glib-2.50:2
	dev-libs/libxml2:2
	dev-libs/libayatana-appindicator
	>=gnome-base/dconf-0.13.4
	>=gnome-base/librsvg-2.0:2
	>=mate-base/libmatekbd-1.28.0
	>=mate-base/mate-desktop-$(ver_cut 1-2)
	>=mate-base/caja-1.28.0
	>=mate-base/mate-menus-1.28.0
	>=media-libs/fontconfig-1:1.0
	media-libs/freetype:2
	|| (
		media-libs/libcanberra-gtk3
		media-libs/libcanberra[gtk3(-)]
	)
	sys-auth/polkit[introspection]
	x11-apps/xmodmap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcursor
	x11-libs/libXext
	>=x11-libs/libXi-1.5
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-libs/libxklavier-4
	x11-libs/pango
	>=x11-wm/marco-1.17.0:=
	accountsservice? ( sys-apps/accountsservice )
	systemd? ( sys-apps/systemd )
"

RDEPEND="${COMMON_DEPEND}"

BDEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	dev-util/desktop-file-utils
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	x11-base/xorg-proto
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.28.0-optional-systemd.patch
)

src_configure() {
	mate_src_configure \
		--disable-update-mimedb \
		$(use_enable nls) \
		$(use_enable debug)
}
