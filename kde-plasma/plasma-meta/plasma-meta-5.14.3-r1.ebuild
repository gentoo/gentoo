# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5-functions

DESCRIPTION="Merge this to pull in all Plasma 5 packages"
HOMEPAGE="https://www.kde.org/plasma-desktop"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 ~arm x86"
IUSE="bluetooth +browser-integration consolekit crypt +display-manager elogind grub gtk +handbook
+legacy-systray networkmanager pam plymouth +pm-utils pulseaudio +sddm sdk systemd +wallpapers"

REQUIRED_USE="?? ( consolekit elogind systemd )"

RDEPEND="
	$(add_plasma_dep breeze)
	$(add_plasma_dep drkonqi)
	$(add_plasma_dep kactivitymanagerd)
	$(add_plasma_dep kde-cli-tools)
	$(add_plasma_dep kdecoration)
	$(add_plasma_dep kdeplasma-addons)
	$(add_plasma_dep kgamma)
	$(add_plasma_dep khotkeys)
	$(add_plasma_dep kinfocenter)
	$(add_plasma_dep kmenuedit)
	$(add_plasma_dep kscreen)
	$(add_plasma_dep kscreenlocker)
	$(add_plasma_dep ksshaskpass)
	$(add_plasma_dep ksysguard)
	$(add_plasma_dep kwayland-integration)
	$(add_plasma_dep kwin)
	$(add_plasma_dep kwrited)
	$(add_plasma_dep libkscreen)
	$(add_plasma_dep libksysguard)
	$(add_plasma_dep milou)
	$(add_plasma_dep oxygen)
	$(add_plasma_dep plasma-desktop)
	$(add_plasma_dep plasma-integration)
	$(add_plasma_dep plasma-workspace)
	$(add_plasma_dep polkit-kde-agent)
	$(add_plasma_dep powerdevil)
	$(add_plasma_dep systemsettings)
	$(add_plasma_dep user-manager)
	sys-apps/dbus[elogind?,systemd?]
	sys-auth/polkit[elogind?,systemd?]
	sys-fs/udisks:2[elogind?,systemd?]
	bluetooth? ( $(add_plasma_dep bluedevil) )
	browser-integration? ( $(add_plasma_dep plasma-browser-integration) )
	consolekit? (
		>=sys-auth/consolekit-1.0.1
		pm-utils? ( sys-power/pm-utils )
	)
	crypt? ( $(add_plasma_dep plasma-vault) )
	display-manager? (
		sddm? (
			$(add_plasma_dep sddm-kcm)
			x11-misc/sddm[consolekit?,elogind?,systemd?]
		)
		!sddm? ( x11-misc/lightdm )
	)
	grub? ( $(add_plasma_dep breeze-grub) )
	gtk? (
		$(add_plasma_dep breeze-gtk)
		$(add_plasma_dep kde-gtk-config)
	)
	handbook? ( $(add_kdeapps_dep khelpcenter) )
	legacy-systray? ( $(add_plasma_dep xembed-sni-proxy) )
	networkmanager? (
		$(add_plasma_dep plasma-nm)
		net-misc/networkmanager[consolekit?,elogind?,systemd?]
	)
	pam? (
		$(add_plasma_dep kwallet-pam)
		sys-auth/pambase[consolekit?,elogind?,systemd?]
	)
	plymouth? (
		$(add_plasma_dep breeze-plymouth)
		$(add_plasma_dep plymouth-kcm)
	)
	pulseaudio? ( $(add_plasma_dep plasma-pa) )
	sdk? ( $(add_plasma_dep plasma-sdk) )
	wallpapers? ( $(add_plasma_dep plasma-workspace-wallpapers) )
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
