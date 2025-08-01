# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson xdg

DESCRIPTION="Collection of developer-oriented UPnP tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gupnp-tools"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=net-libs/gssdp-1.6.2:1.6=
	>=net-libs/gupnp-1.6.0:1.6=
	>=net-libs/libsoup-3.0:3.0
	>=net-libs/gupnp-av-0.5.5:0=
	>=x11-libs/gtk+-3.10:3
	>=dev-libs/glib-2.68:2
	>=dev-libs/libxml2-2.4:2=
	x11-libs/gtksourceview:4
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default

	# This makes sense for upstream but not for us downstream, bug #907384.
	sed -i -e '/-Werror=deprecated-declarations/d' meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dav-tools=true
	)
	meson_src_configure
}
