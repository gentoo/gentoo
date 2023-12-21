# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
else
	KEYWORDS=""
fi

DESCRIPTION="Several Caja extensions"
LICENSE="GPL-2+"
SLOT="0"

SENDTO="cdr gajim +mail pidgin upnp"
IUSE="image-converter nls +open-terminal share +wallpaper xattr media ${SENDTO}"

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	>=mate-base/caja-1.21.3
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	gajim? (
		>=dev-libs/dbus-glib-0.60
		>=sys-apps/dbus-1
	)
	open-terminal? ( >=mate-base/mate-desktop-1.17.0 )
	pidgin? ( >=dev-libs/dbus-glib-0.60 )
	upnp? ( >=net-libs/gupnp-0.13:0= )
	xattr? ( sys-apps/attr )
"

RDEPEND="${COMMON_DEPEND}
	mate-base/mate-desktop
	cdr? ( >=app-cdr/brasero-2.32.1:= )
	gajim? ( net-im/gajim )
	image-converter? (
		|| (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
		)
	)
	media? ( media-video/totem )
	pidgin? ( net-im/pidgin )
"

BDEPEND="${COMMON_DEPEND}
	dev-libs/libxml2
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local sendto_plugins="removable-devices"
	use cdr && sendto_plugins+=",caja-burn"
	use mail && sendto_plugins+=",emailclient"
	use media && sendto_plugins+=",totem"
	use pidgin && sendto_plugins+=",pidgin"
	use gajim && sendto_plugins+=",gajim"
	use upnp && sendto_plugins+=",upnp"

	mate_src_configure \
		--enable-sendto \
		--with-sendto-plugins=${sendto_plugins}\
		--disable-gksu \
		$(use_enable image-converter) \
		$(use_enable media av) \
		$(use_enable nls) \
		$(use_enable open-terminal) \
		$(use_enable share) \
		$(use_enable wallpaper) \
		$(use_enable xattr xattr-tags)
}
