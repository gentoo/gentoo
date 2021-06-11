# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit meson gnome2-utils python-any-r1 xdg-utils

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-session"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc ipv6 systemd"

DEPEND="
	>=dev-libs/glib-2.37.3:2
	media-libs/libcanberra[pulseaudio]
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	>=x11-libs/xapps-2.2.0

	systemd? ( >=sys-apps/systemd-183 )
	!systemd? ( sys-auth/elogind[policykit] )
"
RDEPEND="
	${DEPEND}
	>=gnome-extra/cinnamon-desktop-5.0:0=
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig

	doc? (
		app-text/xmlto
		dev-libs/libxslt )
"

src_prepare() {
	default
	python_fix_shebang data
}

src_configure() {
	local emesonargs=(
		-Dgconf=false
		$(meson_use doc docbook)
		$(meson_use ipv6)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
