# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson systemd

MY_P=${PN}-v${PV}
DESCRIPTION="Realtime Policy and Watchdog Daemon"
HOMEPAGE="https://gitlab.freedesktop.org/pipewire/rtkit"
SRC_URI="https://gitlab.freedesktop.org/pipewire/rtkit/-/archive/v${PV}/${MY_P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="selinux systemd"

DEPEND="
	acct-group/rtkit
	acct-user/rtkit
	sys-apps/dbus
	sys-auth/polkit
	sys-libs/libcap
	systemd? ( sys-apps/systemd )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rtkit )
"
BDEPEND="
	dev-util/xxd
	virtual/pkgconfig
"

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
		-Dsystemd_systemunitdir="$(systemd_get_systemunitdir)"
	)

	meson_src_configure
}
