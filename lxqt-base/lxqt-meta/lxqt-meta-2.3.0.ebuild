# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Meta ebuild for LXQt, the Lightweight Desktop Environment"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="metapackage"
SLOT="0"

IUSE="
	+about admin +archiver +desktop-portal +display-manager +filemanager
	+icons +lximage nls +policykit powermanagement +processviewer +screenshot
	+sddm ssh-askpass +sudo +terminal +trash wayland +window-manager
"

REQUIRED_USE="trash? ( filemanager )"

RDEPEND="
	=lxqt-base/lxqt-config-${MY_PV}*
	=lxqt-base/lxqt-globalkeys-${MY_PV}*
	=lxqt-base/lxqt-menu-data-${MY_PV}*
	=lxqt-base/lxqt-notificationd-${MY_PV}*
	=lxqt-base/lxqt-panel-${MY_PV}*
	=lxqt-base/lxqt-qtplugin-${MY_PV}*
	=lxqt-base/lxqt-runner-${MY_PV}*
	=lxqt-base/lxqt-session-${MY_PV}*
	virtual/ttf-fonts
	x11-terms/xterm
	=x11-themes/lxqt-themes-${MY_PV}*
	about? ( =lxqt-base/lxqt-about-${MY_PV}* )
	admin? ( =lxqt-base/lxqt-admin-${MY_PV}* )
	archiver? ( >=app-arch/lxqt-archiver-1.0 )
	desktop-portal? ( >=gui-libs/xdg-desktop-portal-lxqt-1.1 )
	display-manager? (
		sddm? ( x11-misc/sddm )
		!sddm? ( x11-misc/lightdm )
	)
	filemanager? ( =x11-misc/pcmanfm-qt-${MY_PV}* )
	icons? ( kde-frameworks/breeze-icons:6 )
	lximage? ( =media-gfx/lximage-qt-${MY_PV}* )
	nls? ( dev-qt/qttranslations:6 )
	policykit? ( =lxqt-base/lxqt-policykit-${MY_PV}* )
	powermanagement? ( =lxqt-base/lxqt-powermanagement-${MY_PV}* )
	processviewer? ( >=x11-misc/qps-2.10 )
	screenshot? ( >=x11-misc/screengrab-2.9 )
	sddm? ( x11-misc/sddm )
	ssh-askpass? ( =lxqt-base/lxqt-openssh-askpass-${MY_PV}* )
	sudo? ( =lxqt-base/lxqt-sudo-${MY_PV}* )
	terminal? ( =x11-terms/qterminal-${MY_PV}* )
	trash? ( gnome-base/gvfs )
	wayland? ( lxqt-base/lxqt-wayland-session )
	window-manager? (
		kde-plasma/systemsettings:6
		wayland? ( kde-plasma/kwin:6 )
		!wayland? ( kde-plasma/kwin-x11:6 )
	)
"
