# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit meson multilib-minimal ninja-utils systemd

DESCRIPTION="Optimise Linux system performance on demand"
HOMEPAGE="https://github.com/FeralInteractive/gamemode"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/FeralInteractive/gamemode.git"
	GAMEMODE_GIT_PTR="master"
	inherit git-r3
else
	GAMEMODE_GIT_PTR="${PV}"
	SRC_URI="https://github.com/FeralInteractive/gamemode/releases/download/${GAMEMODE_GIT_PTR}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="systemd elogind"

REQUIRED_USE="^^ ( systemd elogind )"

RDEPEND="
	acct-group/gamemode
	>=dev-libs/inih-53
	sys-apps/dbus[${MULTILIB_USEDEP},systemd(+)=,elogind(-)=]
	sys-auth/polkit
	sys-libs/libcap
"
DEPEND="${RDEPEND}"

DOCS=(
	CHANGELOG.md
	LICENSE.txt
	README.md
	example/gamemode.ini
)

pkg_pretend() {
	elog
	elog "GameMode needs a kernel capable of SCHED_ISO to use its soft realtime"
	elog "feature. Example of a kernel providing that is sys-kernel/pf-sources."
	elog
	elog "Support for soft realtime is completely optional. It may provide the"
	elog "following benefits with systems having at least four CPU cores:"
	elog
	elog "  * more CPU shares allocated exclusively to the game"
	elog "  * reduced input lag and reduced thread latency"
	elog "  * more consistent frame times resulting in less microstutters"
	elog
	elog "You probably won't benefit from soft realtime mode and thus don't need"
	elog "SCHED_ISO if:"
	elog
	elog "  * Your CPU has less than four cores because the game may experience"
	elog "    priority inversion with the graphics driver (thus heuristics"
	elog "    automatically disable SCHED_ISO usage then)"
	elog "  * Your game uses busy-loops to interface with the graphics driver"
	elog "    but you may still force SCHED_ISO per configuation file, YMMV,"
	elog "    it depends on the graphics driver implementation, i.e. usage of"
	elog "    __GL_THREADED_OPTIMIZATIONS or similar."
	elog "  * If your game causes more than 70% CPU usage across all cores,"
	elog "    SCHED_ISO automatically turns off and on depending on usage and"
	elog "    is processed with higher-than-normal priority then (renice)."
	elog "    This auto-switching may result in a lesser game experience."
	elog
	elog "For more info look at:"
	elog "https://github.com/FeralInteractive/gamemode/blob/${GAMEMODE_GIT_PTR}/README.md"
	elog
}

multilib_src_configure() {
	local emesonargs=(
		-Dwith-sd-bus-provider=$(usex systemd "systemd" "elogind")
		-Dwith-systemd-user-unit-dir="$(systemd_get_userunitdir)"
	)
	if ! multilib_is_native_abi; then
		emesonargs+=(
			-Dwith-examples=false
			-Dwith-sd-bus-provider=no-daemon
		)
	fi

	meson_src_configure
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
	if multilib_is_native_abi; then
		insinto /etc/security/limits.d
		newins - 45-gamemode.conf <<-EOF
			@gamemode - nice -10
		EOF
	fi
}

pkg_postinst() {
	elog
	elog "GameMode has optional support for adjusting nice and ioprio of games"
	elog "running with it. You may need to adjust your PAM limits to make use"
	elog "of this. You need to be in the gamemode group for this to work."
	elog
	elog "Run the following command as root to add your user:"
	elog "# gpasswd -a USER gamemode  # with USER = your user name"
	elog
	elog "You can run the following command to test your settings:"
	elog
	elog "# gamemoded -t"
	elog
	elog "GameMode supports GPU optimizations. It defaults to OFF. Any"
	elog "damage resulting from usage of this is your own responsibility."
	elog
	elog "systemd user sessions will automatically run the daemon on demand,"
	elog "it does not need to be enabled explicitly. Games not supporting"
	elog "GameMode natively can still make use of it, just add"
	elog
	elog "gamemoderun %command%"
	elog
	elog "to the start options of any steam game to enable optimizations"
	elog "automatically as you start the game."
	elog
}
