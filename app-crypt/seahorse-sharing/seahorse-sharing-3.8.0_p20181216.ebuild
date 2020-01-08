# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes" # disable asserts
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="Daemon for PGP public key sharing using DNS-SD and HKP"
HOMEPAGE="https://projects.gnome.org/seahorse/"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/master/${PN}-58db1e5b8615d74afaa5d888237ef6556368147b.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	app-crypt/seahorse
	dev-libs/glib:2
	>=net-dns/avahi-0.6:=[dbus]
	net-libs/libsoup:2.4
	>=x11-libs/gtk+-3:3

	>=app-crypt/gpgme-1
	>=app-crypt/gnupg-1.4
"
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-3.2
"
# ${PN} was part of seahorse before 3.2
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-master-58db1e5b8615d74afaa5d888237ef6556368147b"

src_prepare() {
	DOCS="AUTHORS MAINTAINERS NEWS" # ChangeLog has nothing useful
	# Do not pass --enable-tests to configure - package has no tests

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version net-dns/avahi && \
		! rc-config list default | grep -q "avahi-daemon" ; then
		elog "To use ${PN}, the Avahi daemon must be running. On an OpenRC"
		elog "system, you can start the Avahi daemon by"
		elog "# /etc/init.d/avahi-daemon start"
		elog "To start Avahi automatically, add it to the default runlevel:"
		elog "# rc-update add avahi-daemon default"
	fi
}
