# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Merge this to pull in all Plasma 5 packages"
HOMEPAGE="https://kde.org/plasma-desktop/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="accessibility bluetooth +browser-integration colord +crash-handler crypt
cups +desktop-portal discover +display-manager +elogind +firewall flatpak grub
gtk +handbook +kwallet +legacy-systray +networkmanager plymouth pulseaudio +sddm
sdk +smart systemd thunderbolt +wallpapers"

REQUIRED_USE="^^ ( elogind systemd )"

RDEPEND="
	>=kde-plasma/breeze-${PV}:${SLOT}
	>=kde-plasma/kactivitymanagerd-${PV}:${SLOT}
	>=kde-plasma/kde-cli-tools-${PV}:${SLOT}
	>=kde-plasma/kdecoration-${PV}:${SLOT}
	>=kde-plasma/kdeplasma-addons-${PV}:${SLOT}
	>=kde-plasma/kgamma-${PV}:${SLOT}
	>=kde-plasma/khotkeys-${PV}:${SLOT}
	>=kde-plasma/kinfocenter-${PV}:${SLOT}
	>=kde-plasma/kmenuedit-${PV}:${SLOT}
	>=kde-plasma/kscreen-${PV}:${SLOT}
	>=kde-plasma/kscreenlocker-${PV}:${SLOT}
	>=kde-plasma/ksshaskpass-${PV}:${SLOT}
	>=kde-plasma/ksystemstats-${PV}:${SLOT}
	>=kde-plasma/kwayland-integration-${PV}:${SLOT}
	>=kde-plasma/kwin-${PV}:${SLOT}[lock]
	>=kde-plasma/kwrited-${PV}:${SLOT}
	>=kde-plasma/layer-shell-qt-${PV}:${SLOT}
	>=kde-plasma/libkscreen-${PV}:${SLOT}
	>=kde-plasma/libksysguard-${PV}:${SLOT}
	>=kde-plasma/milou-${PV}:${SLOT}
	>=kde-plasma/oxygen-${PV}:${SLOT}
	>=kde-plasma/oxygen-sounds-${PV}:${SLOT}
	>=kde-plasma/plasma-desktop-${PV}:${SLOT}
	>=kde-plasma/plasma-integration-${PV}:${SLOT}
	>=kde-plasma/plasma-systemmonitor-${PV}:${SLOT}
	>=kde-plasma/plasma-welcome-${PV}:${SLOT}
	>=kde-plasma/plasma-workspace-${PV}:${SLOT}
	>=kde-plasma/polkit-kde-agent-${PV}:*
	>=kde-plasma/powerdevil-${PV}:${SLOT}
	>=kde-plasma/systemsettings-${PV}:${SLOT}
	sys-apps/dbus[elogind?,systemd?]
	sys-auth/polkit[systemd?]
	sys-fs/udisks:2[elogind?,systemd?]
	bluetooth? ( >=kde-plasma/bluedevil-${PV}:${SLOT} )
	browser-integration? ( >=kde-plasma/plasma-browser-integration-${PV}:${SLOT} )
	colord? ( x11-misc/colord )
	crash-handler? ( >=kde-plasma/drkonqi-${PV}:${SLOT} )
	crypt? ( >=kde-plasma/plasma-vault-${PV}:${SLOT} )
	cups? ( kde-plasma/print-manager:${SLOT} )
	desktop-portal? ( >=kde-plasma/xdg-desktop-portal-kde-${PV}:${SLOT} )
	discover? ( >=kde-plasma/discover-${PV}:${SLOT} )
	display-manager? (
		sddm? (
			>=kde-plasma/sddm-kcm-${PV}:${SLOT}
			x11-misc/sddm[elogind?,systemd?]
		)
		!sddm? ( x11-misc/lightdm )
	)
	elogind? ( sys-auth/elogind[pam] )
	flatpak? ( >=kde-plasma/flatpak-kcm-${PV}:${SLOT} )
	grub? ( >=kde-plasma/breeze-grub-${PV}:${SLOT} )
	gtk? (
		>=kde-plasma/breeze-gtk-${PV}:${SLOT}
		>=kde-plasma/kde-gtk-config-${PV}:${SLOT}
		x11-misc/appmenu-gtk-module
	)
	handbook? ( kde-apps/khelpcenter:5 )
	kwallet? ( >=kde-plasma/kwallet-pam-${PV}:${SLOT} )
	legacy-systray? ( >=kde-plasma/xembed-sni-proxy-${PV}:${SLOT} )
	networkmanager? (
		>=kde-plasma/plasma-nm-${PV}:${SLOT}
		net-misc/networkmanager[elogind?,systemd?]
	)
	plymouth? (
		>=kde-plasma/breeze-plymouth-${PV}:${SLOT}
		>=kde-plasma/plymouth-kcm-${PV}:${SLOT}
	)
	pulseaudio? ( >=kde-plasma/plasma-pa-${PV}:${SLOT} )
	sdk? ( >=kde-plasma/plasma-sdk-${PV}:${SLOT} )
	smart? ( >=kde-plasma/plasma-disks-${PV}:${SLOT} )
	systemd? (
		sys-apps/systemd[pam]
		firewall? ( >=kde-plasma/plasma-firewall-${PV}:${SLOT} )
	)
	thunderbolt? ( >=kde-plasma/plasma-thunderbolt-${PV}:${SLOT} )
	wallpapers? ( >=kde-plasma/plasma-workspace-wallpapers-${PV}:${SLOT} )
"
# Optional runtime deps: kde-plasma/plasma-desktop
RDEPEND="${RDEPEND}
	accessibility? ( app-accessibility/orca )
"

pkg_postinst() {
	has_version sys-auth/consolekit || return
	ewarn "An existing installation of sys-auth/consolekit was detected even though"
	ewarn "${PN} was configured with USE $(usex elogind elogind systemd)."
	ewarn "There can only be one session manager at runtime, otherwise random issues"
	ewarn "may occur. Please make sure USE consolekit is nowhere enabled in make.conf"
	ewarn "or package.use and remove sys-auth/consolekit before raising bugs."
	ewarn "For more information, visit https://wiki.gentoo.org/wiki/KDE"
}
