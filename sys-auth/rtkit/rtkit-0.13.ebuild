# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info meson

DESCRIPTION="Realtime Policy and Watchdog Daemon"
HOMEPAGE="https://0pointer.de/blog/projects/rtkit"
SRC_URI="https://github.com/heftig/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="systemd"

BDEPEND="virtual/pkgconfig"
DEPEND="acct-group/rtkit
	acct-user/rtkit
	sys-apps/dbus
	sys-auth/polkit
	sys-libs/libcap
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if use kernel_linux; then
		CONFIG_CHECK="~!RT_GROUP_SCHED"
		ERROR_RT_GROUP_SCHED="CONFIG_RT_GROUP_SCHED is enabled. rtkit-daemon (or any other "
		ERROR_RT_GROUP_SCHED+="real-time task) will not work unless run as root. Please consider "
		ERROR_RT_GROUP_SCHED+="unsetting this option."
		check_extra_config
	fi
}

src_configure() {
	local emesonargs=(
		-Dinstalled_tests=false
		$(meson_feature systemd libsystemd)
	)
	meson_src_configure
}
