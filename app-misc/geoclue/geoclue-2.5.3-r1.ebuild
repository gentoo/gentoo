# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.32"

inherit gnome.org meson systemd vala user xdg

DESCRIPTION="A geoinformation D-Bus service"
HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/wikis/home"
SRC_URI="https://gitlab.freedesktop.org/geoclue/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
#todo maybe add a use flat for libgeoclue
IUSE="+introspection gtk-doc modemmanager vala zeroconf"

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-0.14
	>=net-libs/libsoup-2.42:2.4
	sys-apps/dbus
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	modemmanager? ( >=net-misc/modemmanager-1.6 )
	zeroconf? ( >=net-dns/avahi-0.6.10[dbus] )
	!<sci-geosciences/geocode-glib-3.10.0
	x11-libs/libnotify
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-1
	sys-devel/gettext
	virtual/pkgconfig
	vala? (  $(vala_depend) )
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-optional-vapi.patch

	vala_src_prepare
	sed -i -e "s:'vapigen-ver':'vapigen-$(vala_best_api_version)':" libgeoclue/meson.build || die
	xdg_src_prepare
}

src_configure() {
	# debug only affects CFLAGS
	local emesonargs=(
		$(meson_use gtk-doc)
		$(meson_use vala vapigen)
		-Ddbus-srv-user=geoclue \
		-Denable-backend=true \
		-Dlibgeoclue=true \
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)" \
		-Ddemo-agent=false \
		$(meson_use introspection) \
		$(meson_use modemmanager 3g-source) \
		$(meson_use modemmanager cdma-source) \
		$(meson_use modemmanager modem-gps-source) \
		$(meson_use zeroconf nmea-source)
	)
	meson_src_configure
}

pkg_preinst() {
	enewgroup geoclue
	enewuser geoclue -1 -1 /var/lib/geoclue geoclue
}
