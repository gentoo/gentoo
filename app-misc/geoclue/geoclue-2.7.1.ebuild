# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="xml(+)"

inherit meson python-any-r1 systemd vala xdg

DESCRIPTION="A location information D-Bus service"
HOMEPAGE="https://gitlab.freedesktop.org/geoclue/geoclue/-/wikis/home"
SRC_URI="https://gitlab.freedesktop.org/geoclue/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1+ GPL-2+"
SLOT="2.0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc x86"
IUSE="+introspection gtk-doc modemmanager vala zeroconf"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.68:2
	>=dev-libs/json-glib-0.14.0
	>=net-libs/libsoup-3.0.0:3.0
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	modemmanager? ( >=net-misc/modemmanager-1.6 )
	zeroconf? ( >=net-dns/avahi-0.6.10[dbus] )
	x11-libs/libnotify
"
RDEPEND="${DEPEND}
	acct-user/geoclue
	sys-apps/dbus
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	gtk-doc? (
		app-text/docbook-xml-dtd:4.1.2
		>=dev-util/gtk-doc-1 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-Dlibgeoclue=true
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc)
		$(meson_use modemmanager 3g-source)
		$(meson_use modemmanager cdma-source)
		$(meson_use modemmanager modem-gps-source)
		$(meson_use zeroconf nmea-source)
		-Dcompass=true
		-Denable-backend=true
		-Ddemo-agent=true
		-Dsystemd-system-unit-dir="$(systemd_get_systemunitdir)"
		-Ddbus-srv-user=geoclue

		-Dmozilla-api-key=f57afde7-113f-4e8f-96d1-62be64a0273c
	)

	DISTRO="$(awk -F= '/^NAME/ {print $2}' /etc/os-release | tr -d \" )"
	if [[ $DISTRO != Gentoo ]]; then
		eerror "The following API key has been allocated for Gentoo only."
		eerror "If you are a derivative, please request your own key as discussed here:"
		eerror "https://gitlab.freedesktop.org/geoclue/geoclue/-/issues/136"
		eerror "See also: https://location.services.mozilla.com/api and"
		eerror "https://blog.mozilla.org/services/2019/09/03/a-new-policy-for-mozilla-location-service/"
		die "Please request an API key for your distribution."
	fi

	meson_src_configure
}
