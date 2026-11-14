# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit pkagent-autostart

DESCRIPTION="Polkit authentication autostart for xfce4"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-session/start
	https://gitlab.xfce.org/xfce/xfce4-session
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
#"~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="kde lxde lxqt"
REQUIRED_USE="?? ( kde lxde lxqt )"

RDEPEND="
	kde? ( kde-plasma/polkit-kde-agent:6 )
	lxde? ( >=lxde-base/lxsession-0.5.6-r1 )
	lxqt? ( lxqt-base/lxqt-policykit )
	!kde? ( !lxde? ( !lxqt? ( gnome-extra/polkit-gnome ) ) )
"

src_install() {
	use kde && make_pkagent_autostart_entry XFCE polkit-kde-agent
	use lxde && make_pkagent_autostart_entry XFCE lxsession
	use lxqt && make_pkagent_autostart_entry XFCE lxqt-policykit
	use kde || use lxde || use lxqt ||
		make_pkagent_autostart_entry XFCE polkit-gnome
}
