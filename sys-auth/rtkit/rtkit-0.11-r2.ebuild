# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils systemd user autotools linux-info

DESCRIPTION="Realtime Policy and Watchdog Daemon"
HOMEPAGE="http://0pointer.de/blog/projects/rtkit"
SRC_URI="http://0pointer.de/public/${P}.tar.xz"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

RDEPEND="
	sys-apps/dbus
	sys-auth/polkit
	sys-libs/libcap
"
DEPEND="${RDEPEND}"

PATCHES=(
	# Fedora patches
	"${FILESDIR}/${P}-polkit.patch"
	"${FILESDIR}/${P}-gettime.patch"
	"${FILESDIR}/${P}-controlgroup.patch"
)

pkg_pretend() {
	if use kernel_linux; then
		CONFIG_CHECK="~!RT_GROUP_SCHED"
		ERROR_RT_GROUP_SCHED="CONFIG_RT_GROUP_SCHED is enabled. rtkit-daemon (or any other "
		ERROR_RT_GROUP_SCHED+="real-time task) will not work unless run as root. Please consider "
		ERROR_RT_GROUP_SCHED+="unsetting this option."
		check_extra_config
	fi
}

pkg_setup() {
	enewgroup rtkit
	enewuser rtkit -1 -1 -1 "rtkit"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

src_install() {
	default

	./rtkit-daemon --introspect > org.freedesktop.RealtimeKit1.xml
	insinto /usr/share/dbus-1/interfaces
	doins org.freedesktop.RealtimeKit1.xml
}
