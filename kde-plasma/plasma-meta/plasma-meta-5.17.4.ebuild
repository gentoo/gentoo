# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Merge this to pull in all Plasma 5 packages"
HOMEPAGE="https://kde.org/plasma-desktop"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="bluetooth +browser-integration consolekit crypt +desktop-portal discover
+display-manager elogind grub gtk +handbook +legacy-systray networkmanager pam
plymouth +pm-utils pulseaudio qrcode +sddm sdk systemd thunderbolt +wallpapers"

REQUIRED_USE="?? ( consolekit elogind systemd )"

RDEPEND="
	>=kde-plasma/breeze-${PV}:${SLOT}
	>=kde-plasma/drkonqi-${PV}:${SLOT}
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
	>=kde-plasma/ksysguard-${PV}:${SLOT}
	>=kde-plasma/kwayland-integration-${PV}:${SLOT}
	>=kde-plasma/kwin-${PV}:${SLOT}
	>=kde-plasma/kwrited-${PV}:${SLOT}
	>=kde-plasma/libkscreen-${PV}:${SLOT}
	>=kde-plasma/libksysguard-${PV}:${SLOT}
	>=kde-plasma/milou-${PV}:${SLOT}
	>=kde-plasma/oxygen-${PV}:${SLOT}
	>=kde-plasma/plasma-desktop-${PV}:${SLOT}
	>=kde-plasma/plasma-integration-${PV}:${SLOT}
	>=kde-plasma/plasma-workspace-${PV}:${SLOT}
	>=kde-plasma/polkit-kde-agent-${PV}:${SLOT}
	>=kde-plasma/powerdevil-${PV}:${SLOT}
	>=kde-plasma/systemsettings-${PV}:${SLOT}
	>=kde-plasma/user-manager-${PV}:${SLOT}
	sys-apps/dbus[elogind?,systemd?]
	sys-auth/polkit[elogind?,systemd?]
	sys-fs/udisks:2[elogind?,systemd?]
	bluetooth? ( >=kde-plasma/bluedevil-${PV}:${SLOT} )
	browser-integration? ( >=kde-plasma/plasma-browser-integration-${PV}:${SLOT} )
	consolekit? (
		>=sys-auth/consolekit-1.0.1
		pm-utils? ( sys-power/pm-utils )
	)
	crypt? ( >=kde-plasma/plasma-vault-${PV}:${SLOT} )
	desktop-portal? ( >=kde-plasma/xdg-desktop-portal-kde-${PV}:${SLOT} )
	discover? ( >=kde-plasma/discover-${PV}:${SLOT} )
	display-manager? (
		sddm? (
			>=kde-plasma/sddm-kcm-${PV}:${SLOT}
			x11-misc/sddm[consolekit?,elogind?,systemd?]
		)
		!sddm? ( x11-misc/lightdm )
	)
	grub? ( >=kde-plasma/breeze-grub-${PV}:${SLOT} )
	gtk? (
		>=kde-plasma/breeze-gtk-${PV}:${SLOT}
		>=kde-plasma/kde-gtk-config-${PV}:${SLOT}
	)
	handbook? ( kde-apps/khelpcenter:5 )
	legacy-systray? ( >=kde-plasma/xembed-sni-proxy-${PV}:${SLOT} )
	networkmanager? (
		>=kde-plasma/plasma-nm-${PV}:${SLOT}
		net-misc/networkmanager[consolekit?,elogind?,systemd?]
		qrcode? ( kde-frameworks/prison[qml] )
	)
	pam? (
		>=kde-plasma/kwallet-pam-${PV}:${SLOT}
		sys-auth/pambase[consolekit?,elogind?,systemd?]
	)
	plymouth? (
		>=kde-plasma/breeze-plymouth-${PV}:${SLOT}
		>=kde-plasma/plymouth-kcm-${PV}:${SLOT}
	)
	pulseaudio? ( >=kde-plasma/plasma-pa-${PV}:${SLOT} )
	sdk? ( >=kde-plasma/plasma-sdk-${PV}:${SLOT} )
	thunderbolt? ( >=kde-plasma/plasma-thunderbolt-${PV}:${SLOT} )
	wallpapers? ( >=kde-plasma/plasma-workspace-wallpapers-${PV}:${SLOT} )
"

pkg_postinst() {
	local i selected use_pkg_map=(
		consolekit:sys-auth/consolekit
		elogind:sys-auth/elogind
		systemd:sys-apps/systemd
	)
	for i in ${use_pkg_map[@]}; do
		use ${i%:*} && selected="${i%:*}"
	done
	for i in ${use_pkg_map[@]}; do
		if ! use ${i%:*} && has_version ${i#*:}; then
			ewarn "An existing installation of ${i#*:} was detected even though"
			ewarn "${PN} was configured with USE ${selected} instead of ${i%:*}."
			ewarn "There can only be one session manager at runtime, otherwise random issues"
			ewarn "may occur. Please make sure USE ${i%:*} is nowhere enabled in make.conf"
			ewarn "or package.use and remove ${i#*:} before raising bugs."
			ewarn "For more information, visit https://wiki.gentoo.org/wiki/KDE"
		fi
	done
}
