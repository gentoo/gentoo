# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit meson vala gnome2-utils python-any-r1

MY_PN="SwayNotificationCenter"
DESCRIPTION="A simple notification daemon with a GTK gui for notifications and control center"
HOMEPAGE="https://github.com/ErikReider/SwayNotificationCenter"
SRC_URI="https://github.com/ErikReider/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pulseaudio"

DEPEND="
	dev-lang/sassc
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/granite:=
	dev-libs/json-glib
	dev-libs/libgee:0.8=
	dev-libs/wayland
	>=gui-libs/gtk-layer-shell-0.8.0[introspection,vala]
	gui-libs/libhandy:1
	sys-apps/dbus
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	pulseaudio? ( media-libs/libpulse )
"
RDEPEND="
	${DEPEND}
	x11-libs/cairo
	x11-libs/pango
"

BDEPEND="
	${PYTHON_DEPS}
	$(vala_depend)
	app-text/scdoc
"

src_configure() {
	local emesonargs=($(meson_use pulseaudio pulse-audio))
	meson_src_configure
}

src_prepare() {
	default
	vala_setup
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
