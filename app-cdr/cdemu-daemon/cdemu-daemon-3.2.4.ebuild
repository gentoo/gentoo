# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Daemon of the CDEmu optical media image mounting suite"
HOMEPAGE="https://cdemu.sourceforge.io"
SRC_URI="https://download.sourceforge.net/cdemu/cdemu-daemon/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/7" # subslot = CDEMU_DAEMON_INTERFACE_VERSION_MAJOR in CMakeLists.txt
KEYWORDS="~amd64 ~x86"
IUSE=""

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

pkg_postinst() {
	elog "You will need to load the vhba module to use cdemu devices:"
	elog " # modprobe vhba"
	elog "To automatically load the vhba module at boot time, edit your"
	elog "/etc/conf.d/modules file."

	if [[ -e ${ROOT}/etc/conf.d/cdemud ]]; then
		elog
		elog "${PN} no longer installs an init.d service; instead, it is"
		elog "automatically activated when needed via dbus."
		elog "You can therefore remove ${ROOT}/etc/conf.d/cdemud"
	fi
}
