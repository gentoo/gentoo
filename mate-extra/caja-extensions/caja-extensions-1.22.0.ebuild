# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Several Caja extensions"
LICENSE="GPL-2"
SLOT="0"

SENDTO="cdr gajim +mail pidgin upnp"
IUSE="image-converter +open-terminal share +wallpaper xattr ${SENDTO}"

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	>=mate-base/caja-1.21.3
	virtual/libintl
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	gajim? (
		>=dev-libs/dbus-glib-0.60
		>=sys-apps/dbus-1
	)
	open-terminal? ( >=mate-base/mate-desktop-1.17.0 )
	pidgin? ( >=dev-libs/dbus-glib-0.60 )
	upnp? ( >=net-libs/gupnp-0.13:= )
	xattr? ( sys-apps/attr )"

RDEPEND="${COMMON_DEPEND}
	cdr? ( >=app-cdr/brasero-2.32.1:= )
	gajim? ( net-im/gajim )
	image-converter? (
		|| (
			media-gfx/imagemagick
			media-gfx/graphicsmagick[imagemagick]
		)
	)
	pidgin? ( net-im/pidgin )"

DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.18:*
	sys-devel/gettext:*
	virtual/pkgconfig:*
	!!mate-extra/mate-file-manager-open-terminal
	!!mate-extra/mate-file-manager-sendto
	!!mate-extra/mate-file-manager-image-converter
	!!mate-extra/mate-file-manager-share"

src_configure() {
	local sendto_plugins="removable-devices"
	use cdr && sendto_plugins+=",caja-burn"
	use mail && sendto_plugins+=",emailclient"
	use pidgin && sendto_plugins+=",pidgin"
	use gajim && sendto_plugins+=",gajim"
	use upnp && sendto_plugins+=",upnp"

	mate_src_configure \
		--enable-sendto \
		--with-sendto-plugins=${sendto_plugins}\
		--disable-gksu \
		$(use_enable image-converter) \
		$(use_enable open-terminal) \
		$(use_enable share) \
		$(use_enable wallpaper) \
		$(use_enable xattr xattr-tags)
}
