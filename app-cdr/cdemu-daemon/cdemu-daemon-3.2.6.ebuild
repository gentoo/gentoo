# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake systemd

DESCRIPTION="Daemon of the CDEmu optical media image mounting suite"
HOMEPAGE="https://cdemu.sourceforge.io"
SRC_URI="https://download.sourceforge.net/cdemu/cdemu-daemon/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/7" # subslot = CDEMU_DAEMON_INTERFACE_VERSION_MAJOR in CMakeLists.txt
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/glib-2.38:2
	>=dev-libs/libmirage-3.2.0:=
	>=media-libs/libao-0.8.0:="
RDEPEND="${DEPEND}
	sys-apps/dbus
	>=sys-fs/vhba-20130607"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS README )

src_install() {
	cmake_src_install

	insinto /etc/modules-load.d
	newins - vhba.conf <<<"vhba"
	systemd_douserunit service-example/cdemu-daemon.service
	insinto /usr/share/dbus-1/services
	doins service-example/net.sf.cdemu.CDEmuDaemon.service
}

pkg_postinst() {
	elog "As of 3.2.5, cdemu-daemon no longer supports autoloading"
	elog "on non-systemd systems.  OpenRC users have to start it manually."
	elog
	elog "We install /etc/modules-load.d/vhba.conf to load the module"
	elog "automatically, and D-BUS autolaunch will start cdemu-daemon user"
	elog "service."
}
