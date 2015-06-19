# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdemu-daemon/cdemu-daemon-3.0.2.ebuild,v 1.3 2015/03/27 10:15:08 ago Exp $

EAPI="5"

CMAKE_MIN_VERSION="2.8.5"

inherit cmake-utils eutils

DESCRIPTION="Daemon of the CDEmu optical media image mounting suite"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/7" # subslot = CDEMU_DAEMON_INTERFACE_VERSION_MAJOR in CMakeLists.txt
KEYWORDS="amd64 ~hppa x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.32:2
	>=dev-libs/libmirage-${PV}:=
	>=media-libs/libao-0.8.0:=
	sys-apps/dbus
	>=sys-fs/vhba-20130607"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	DOCS="AUTHORS README"
	cmake-utils_src_prepare
}

pkg_postinst() {
	elog "You will need to load the vhba module to use cdemu devices:"
	elog " # modprobe vhba"
	elog "To automatically load the vhba module at boot time, edit your"
	elog "/etc/conf.d/modules file."

	if [[ -e "${ROOT}etc/conf.d/cdemud" ]]; then
		elog
		elog "${PN} no longer installs an init.d service; instead, it is"
		elog "automatically activated when needed via dbus."
		elog "You can therefore remove ${ROOT}etc/conf.d/cdemud"
	fi
}
