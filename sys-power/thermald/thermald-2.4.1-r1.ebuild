# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools out-of-source systemd

DESCRIPTION="Thermal daemon for Intel architectures"
HOMEPAGE="https://01.org/linux-thermal-daemon https://github.com/intel/thermal_daemon"
SRC_URI="https://github.com/intel/thermal_daemon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/dbus-glib:=
	dev-libs/glib:=
	dev-libs/libxml2:=
	dev-libs/libevdev
	sys-power/upower
	sys-apps/dbus:="
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/glib-utils"

S=${WORKDIR}/thermal_daemon-${PV}
DOCS=( thermal_daemon_usage.txt README.txt )

src_prepare() {
	sed -i -e "/group=/s/power/wheel/g" \
		data/org.freedesktop.thermald.conf || die

	default
	eautoreconf
}

my_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-werror \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

my_src_install_all() {
	einstalldocs

	rm -rf "${ED}"/etc/init || die
	doinitd "${FILESDIR}"/thermald
}

pkg_postinst() {
	if ! has_version sys-power/dptfxtract; then
		elog "dptfxtract can be used to generate a more specific"
		elog "thermald configuration for your system"
	fi
}
