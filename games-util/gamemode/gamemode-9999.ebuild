# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	elog "GameMode requires permissions to adjust your PAM limits and change system"
	elog "performance settings (overclocking, scheduling, L3 cache usage, mitigations"
	elog "etc). This permission is granted via the gamemode group."
	elog
	elog "Run the following command as root to add your user:"
	elog "# gpasswd -a USER gamemode  # with USER = your user name"
	elog
	elog "You can run the following command to test your settings:"
	elog
	elog "# gamemoded -t"
	elog
	elog "GameMode supports GPU optimizations. It defaults to OFF. Any damage"
	elog "resulting from usage of this is your own responsibility.  For safety"
	elog "reasons, GPU settings are not allowed from \$HOME but only from"
	elog "administrative directories."
	elog
	elog "systemd user sessions will automatically run the daemon on demand, it does"
	elog "not need to be enabled explicitly. Games not supporting GameMode natively"
	elog "can still make use of it, just add"
	elog
	elog "gamemoderun %command%"
	elog
	elog "to the start options of any Steam game to enable optimizations automatically"
	elog "as you start the game. Similar options exist for other launchers like"
	elog "Bottles or Lutris."
	elog
}
