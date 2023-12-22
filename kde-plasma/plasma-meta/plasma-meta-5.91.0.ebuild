# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Merge this to pull in all Plasma 6 packages"
HOMEPAGE="https://kde.org/plasma-desktop/"

LICENSE="metapackage"
SLOT="6"
KEYWORDS="~amd64"
IUSE="accessibility bluetooth +browser-integration colord +crash-handler crypt
cups discover +display-manager +elogind +firewall flatpak grub gtk +handbook
+kwallet +networkmanager plymouth pulseaudio +sddm sdk +smart systemd
thunderbolt wacom +wallpapers"

REQUIRED_USE="^^ ( elogind systemd )"

RDEPEND="
	!${CATEGORY}/${PN}:5
	>=kde-plasma/breeze-${PV}:${SLOT}
	>=kde-plasma/kactivitymanagerd-${PV}:${SLOT}
	>=kde-plasma/kde-cli-tools-${PV}:${SLOT}
	>=kde-plasma/kdecoration-${PV}:${SLOT}
	>=kde-plasma/kdeplasma-addons-${PV}:${SLOT}
	>=kde-plasma/kgamma-${PV}:${SLOT}
	>=kde-plasma/kglobalacceld-${PV}:${SLOT}
	>=kde-plasma/kinfocenter-${PV}:${SLOT}
	>=kde-plasma/kmenuedit-${PV}:${SLOT}
	>=kde-plasma/kscreen-${PV}:${SLOT}
	>=kde-plasma/kscreenlocker-${PV}:${SLOT}
	>=kde-plasma/ksshaskpass-${PV}:${SLOT}
	>=kde-plasma/ksystemstats-${PV}:${SLOT}
	>=kde-plasma/kwayland-${PV}:${SLOT}
	>=kde-plasma/kwayland-integration-${PV}:5
	>=kde-plasma/kwin-${PV}:${SLOT}[lock]
	>=kde-plasma/kwrited-${PV}:${SLOT}
	>=kde-plasma/layer-shell-qt-${PV}:${SLOT}
	>=kde-plasma/libkscreen-${PV}:${SLOT}
	>=kde-plasma/libksysguard-${PV}:${SLOT}
	>=kde-plasma/libplasma-${PV}:${SLOT}
	>=kde-plasma/milou-${PV}:${SLOT}
	>=kde-plasma/ocean-sound-theme-${PV}:${SLOT}
	>=kde-plasma/oxygen-${PV}:${SLOT}
	>=kde-plasma/oxygen-sounds-${PV}:${SLOT}
	>=kde-plasma/plasma-activities-${PV}:${SLOT}
	>=kde-plasma/plasma-activities-stats-${PV}:${SLOT}
	>=kde-plasma/plasma-desktop-${PV}:${SLOT}
	>=kde-plasma/plasma-integration-${PV}:${SLOT}
	>=kde-plasma/plasma-systemmonitor-${PV}:${SLOT}
	>=kde-plasma/plasma-welcome-${PV}:${SLOT}
	>=kde-plasma/plasma-workspace-${PV}:${SLOT}
	>=kde-plasma/plasma5support-${PV}:${SLOT}
	>=kde-plasma/polkit-kde-agent-${PV}:*
	>=kde-plasma/powerdevil-${PV}:${SLOT}
	>=kde-plasma/systemsettings-${PV}:${SLOT}
	>=kde-plasma/xdg-desktop-portal-kde-${PV}:${SLOT}
	sys-apps/dbus[elogind?,systemd?]
	sys-auth/polkit[systemd?]
	sys-fs/udisks:2[elogind?,systemd?]
	bluetooth? ( >=kde-plasma/bluedevil-${PV}:${SLOT} )
	browser-integration? ( >=kde-plasma/plasma-browser-integration-${PV}:${SLOT} )
	colord? ( x11-misc/colord )
	crash-handler? ( >=kde-plasma/drkonqi-${PV}:${SLOT} )
	crypt? ( >=kde-plasma/plasma-vault-${PV}:${SLOT} )
	cups? ( >=kde-plasma/print-manager-${PV}:${SLOT} )
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
	handbook? ( kde-apps/khelpcenter:* )
	kwallet? ( >=kde-plasma/kwallet-pam-${PV}:${SLOT} )
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
	wacom? ( >=kde-plasma/wacomtablet-${PV}:${SLOT} )
	wallpapers? ( >=kde-plasma/plasma-workspace-wallpapers-${PV}:${SLOT} )
"
# Optional runtime deps: kde-plasma/plasma-desktop
RDEPEND="${RDEPEND}
	accessibility? ( app-accessibility/orca )
"
