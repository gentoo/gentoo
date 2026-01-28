# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Merge this to pull in all Plasma 6 packages"
HOMEPAGE="https://kde.org/plasma-desktop/"

LICENSE="metapackage"
SLOT="6"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="accessibility bluetooth +browser-integration +crash-handler crypt cups
discover +display-manager +elogind +firewall flatpak grub gtk +kwallet
+networkmanager oxygen-theme plymouth pulseaudio qt5 rdp +sddm sdk +smart systemd
thunderbolt unsupported wacom +wallpapers webengine X +xwayland"

REQUIRED_USE="^^ ( elogind systemd ) firewall? ( systemd )"

RDEPEND="
	!${CATEGORY}/${PN}:5
	!kde-plasma/khotkeys:5
	>=kde-plasma/aurorae-${PV}:${SLOT}
	>=kde-plasma/breeze-${PV}:${SLOT}
	>=kde-plasma/kactivitymanagerd-${PV}:${SLOT}
	>=kde-plasma/kde-cli-tools-${PV}:${SLOT}
	>=kde-plasma/kde-cli-tools-common-${PV}
	>=kde-plasma/kdecoration-${PV}:${SLOT}
	>=kde-plasma/kdeplasma-addons-${PV}:${SLOT}
	>=kde-plasma/kdesu-gui-${PV}[X?]
	>=kde-plasma/keditfiletype-${PV}
	>=kde-plasma/kglobalacceld-${PV}:${SLOT}[X?]
	>=kde-plasma/kinfocenter-${PV}:${SLOT}
	>=kde-plasma/kmenuedit-${PV}:${SLOT}
	>=kde-plasma/knighttime-${PV}:${SLOT}
	>=kde-plasma/kpipewire-${PV}:${SLOT}
	>=kde-plasma/kscreen-${PV}:${SLOT}
	>=kde-plasma/kscreenlocker-${PV}:${SLOT}
	>=kde-plasma/ksshaskpass-${PV}:${SLOT}
	>=kde-plasma/ksystemstats-${PV}:${SLOT}
	>=kde-plasma/kwayland-${PV}:${SLOT}
	>=kde-plasma/kwin-${PV}:${SLOT}[lock]
	>=kde-plasma/kwrited-${PV}:${SLOT}
	>=kde-plasma/layer-shell-qt-${PV}:${SLOT}
	>=kde-plasma/libkscreen-${PV}:${SLOT}
	>=kde-plasma/libksysguard-${PV}:${SLOT}
	>=kde-plasma/libplasma-${PV}:${SLOT}
	>=kde-plasma/milou-${PV}:${SLOT}
	>=kde-plasma/ocean-sound-theme-${PV}:${SLOT}
	>=kde-plasma/plasma-activities-${PV}:${SLOT}
	>=kde-plasma/plasma-activities-stats-${PV}:${SLOT}
	>=kde-plasma/plasma-desktop-${PV}:${SLOT}
	>=kde-plasma/plasma-integration-${PV}:${SLOT}
	>=kde-plasma/plasma-login-sessions-${PV}:${SLOT}[X?]
	>=kde-plasma/plasma-systemmonitor-${PV}:${SLOT}
	>=kde-plasma/plasma-welcome-${PV}:${SLOT}
	>=kde-plasma/plasma-workspace-${PV}:${SLOT}[X?]
	>=kde-plasma/plasma5support-${PV}:${SLOT}
	>=kde-plasma/polkit-kde-agent-${PV}:*
	>=kde-plasma/powerdevil-${PV}:${SLOT}
	>=kde-plasma/qqc2-breeze-style-${PV}:${SLOT}
	>=kde-plasma/systemsettings-${PV}:${SLOT}
	>=kde-plasma/xdg-desktop-portal-kde-${PV}:${SLOT}
	sys-apps/dbus[elogind?,systemd?]
	sys-auth/polkit[systemd?]
	sys-fs/udisks:2[elogind?,systemd?]
	bluetooth? ( >=kde-plasma/bluedevil-${PV}:${SLOT} )
	browser-integration? ( >=kde-plasma/plasma-browser-integration-${PV}:${SLOT} )
	crash-handler? (
		!systemd? ( >=kde-plasma/drkonqi-legacy-6.3.80_p20250417:${SLOT} )
		systemd? ( >=kde-plasma/drkonqi-${PV}:${SLOT} )
	)
	crypt? ( >=kde-plasma/plasma-vault-${PV}:${SLOT} )
	cups? (
		>=kde-plasma/print-manager-${PV}:${SLOT}
		net-print/cups-meta
	)
	discover? ( >=kde-plasma/discover-${PV}:${SLOT} )
	display-manager? (
		sddm? (
			>=kde-plasma/sddm-kcm-${PV}:${SLOT}
			>=x11-misc/sddm-0.21.0_p20240302[elogind?,systemd?]
		)
		!sddm? ( x11-misc/lightdm )
	)
	elogind? ( sys-auth/elogind[pam] )
	flatpak? ( >=kde-plasma/flatpak-kcm-${PV}:${SLOT} )
	grub? ( >=kde-plasma/breeze-grub-${PV}:${SLOT} )
	gtk? (
		>=kde-plasma/breeze-gtk-${PV}:${SLOT}
		>=kde-plasma/kde-gtk-config-${PV}:${SLOT}
		sys-apps/xdg-desktop-portal-gtk
		x11-misc/appmenu-gtk-module
	)
	kwallet? ( >=kde-plasma/kwallet-pam-${PV}:${SLOT} )
	networkmanager? (
		>=kde-plasma/plasma-nm-${PV}:${SLOT}
		net-misc/networkmanager[elogind?,systemd?]
	)
	oxygen-theme? (
		>=kde-frameworks/oxygen-icons-6.0.0:*
		>=kde-plasma/oxygen-${PV}:${SLOT}[X?]
		>=kde-plasma/oxygen-sounds-${PV}:${SLOT}
		qt5? ( >=kde-plasma/oxygen-6.5.0:5[X?] )
	)
	plymouth? (
		>=kde-plasma/breeze-plymouth-${PV}:${SLOT}
		>=kde-plasma/plymouth-kcm-${PV}:${SLOT}
	)
	pulseaudio? ( >=kde-plasma/plasma-pa-${PV}:${SLOT} )
	qt5? (
		>=kde-plasma/breeze-6.5.0:5
		>=kde-plasma/kwayland-integration-${PV}:5
		>=kde-plasma/plasma-integration-6.5.0:5
	)
	rdp? ( >=kde-plasma/krdp-${PV}:${SLOT} )
	sdk? ( >=kde-plasma/plasma-sdk-${PV}:${SLOT} )
	smart? ( >=kde-plasma/plasma-disks-${PV}:${SLOT} )
	systemd? (
		>=sys-apps/systemd-257[pam]
		firewall? ( >=kde-plasma/plasma-firewall-${PV}:${SLOT} )
	)
	thunderbolt? ( >=kde-plasma/plasma-thunderbolt-${PV}:${SLOT} )
	!unsupported? ( !gui-apps/qt6ct )
	wacom? ( >=kde-plasma/plasma-desktop-${PV}:${SLOT}[input_devices_wacom] )
	wallpapers? ( >=kde-plasma/plasma-workspace-wallpapers-${PV}:${SLOT} )
	webengine? ( kde-apps/khelpcenter:6 )
	X? (
		>=kde-plasma/kgamma-${PV}:${SLOT}
		>=kde-plasma/kwin-x11-${PV}:${SLOT}[lock]
		wacom? ( >=kde-plasma/wacomtablet-${PV}:${SLOT} )
	)
	xwayland? ( >=gui-apps/xwaylandvideobridge-0.4.0_p20250215-r1 )
"
# NOTE spectacle moved from KDE Gear (yy.mm) to KDE Plasma version scheme
# TODO drop after 2027-04-26
case ${PV} in
	*9999) RDEPEND+=" ~kde-plasma/spectacle-${PV}:${SLOT}" ;;
	*)
		RDEPEND+="
			>=kde-plasma/spectacle-$(ver_cut 1-3):${SLOT}
			<kde-plasma/spectacle-15
		"
		;;
esac
# Optional runtime deps: kde-plasma/plasma-desktop
RDEPEND="${RDEPEND}
	accessibility? ( app-accessibility/orca )
"

pkg_postinst() {
	if [[ $(tc-get-cxx-stdlib) == "libc++" ]] ; then
		# Workaround for bug #923292 (KDE-bug 479679)
		ewarn "plasmashell and other KDE Plasma components are known to misbehave"
		ewarn "when built with llvm-runtimes/libcxx, e.g. crashing when right-clicking"
		ewarn "on a panel. See bug #923292."
		ewarn ""
		ewarn "A possible (no warranty!) workaround is building llvm-runtimes/libcxx and"
		ewarn "llvm-runtimes/libcxxabi with the following in package.env:"
		ewarn " MYCMAKEARGS=\"-DLIBCXX_TYPEINFO_COMPARISON_IMPLEMENTATION=2\""
		ewarn "You may then need to rebuild dev-qt/* and kde-*/*."
	fi

	if ! use qt5 && has_version dev-qt/qtgui; then
		ewarn "KF5- and Qt5-based applications will exhibit various integration bugs"
		ewarn "and generally look out of place in Plasma 6 without the dependencies"
		ewarn "enforced by kde-plasma/plasma-meta[qt5]."
		ewarn
		ewarn "This warning message is being displayed because dev-qt/qtgui:5 is"
		ewarn "currently installed which indicates the use of such applications."
	fi
}
