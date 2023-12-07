# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit meson-multilib systemd

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
	>=dev-libs/inih-54
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

multilib_src_configure() {
	local emesonargs=(
		-Dwith-examples=false
		-Dwith-pam-limits-dir="${EPREFIX}"/etc/security/limits.d
		-Dwith-pam-renicing=true
		-Dwith-privileged-group=gamemode
		-Dwith-systemd-user-unit-dir="$(systemd_get_userunitdir)"
	)
	if multilib_is_native_abi; then
		emesonargs+=(
			-Dwith-sd-bus-provider=$(usex systemd systemd elogind)
			-Dwith-util=true
		)
	else
		emesonargs+=(
			-Dwith-sd-bus-provider=no-daemon
			-Dwith-util=false
		)
	fi

	meson_src_configure
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
