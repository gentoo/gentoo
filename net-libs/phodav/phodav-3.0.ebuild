# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson systemd udev

DESCRIPTION="WebDav server implementation using libsoup"
HOMEPAGE="https://wiki.gnome.org/phodav https://gitlab.gnome.org/GNOME/phodav"

LICENSE="LGPL-2.1+"
SLOT="3.0"
KEYWORDS="~alpha amd64 arm arm64 ppc ppc64 ~riscv x86"
IUSE="gtk-doc systemd test zeroconf"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.51.2:2
	>=net-libs/libsoup-3.0.0:3.0
	dev-libs/libxml2
	zeroconf? ( net-dns/avahi[dbus] )

	!net-libs/phodav:2.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? ( gnome-base/dconf )
"

src_prepare() {
	default

	if ! use zeroconf ; then
		sed -i -e 's|avahi-daemon.service||' data/spice-webdavd.service || die
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_feature gtk-doc gtk_doc)
		$(meson_feature zeroconf avahi)
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dudevrulesdir="$(get_udevdir)/rules.d"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use systemd ; then
		newinitd "${FILESDIR}/spice-webdavd.initd" spice-webdavd
		udev_dorules "${FILESDIR}/70-spice-webdavd.rules"
	fi
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
