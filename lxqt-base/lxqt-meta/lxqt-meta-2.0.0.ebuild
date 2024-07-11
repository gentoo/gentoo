# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="Meta ebuild for LXQt, the Lightweight Desktop Environment"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="metapackage"
SLOT="0"

IUSE="
	+about admin +archiver +desktop-portal +display-manager +filemanager
	+lximage nls +policykit powermanagement +processviewer +screenshot
	+sddm ssh-askpass +sudo +terminal +trash +window-manager
"

REQUIRED_USE="trash? ( filemanager )"

# Pull in 'kde-frameworks/breeze-icons' as an upstream default.
# https://bugs.gentoo.org/543380
# https://github.com/lxqt/lxqt-session/commit/5d32ff434d4
RDEPEND="
	kde-frameworks/breeze-icons:6
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
	desktop-portal? ( >=gui-libs/xdg-desktop-portal-lxqt-1.0 )
	display-manager? (
		sddm? ( x11-misc/sddm )
		!sddm? ( x11-misc/lightdm )
	)
	filemanager? ( =x11-misc/pcmanfm-qt-${MY_PV}* )
	lximage? ( =media-gfx/lximage-qt-${MY_PV}* )
	nls? ( dev-qt/qttranslations:6 )
	policykit? ( =lxqt-base/lxqt-policykit-${MY_PV}* )
	powermanagement? ( =lxqt-base/lxqt-powermanagement-${MY_PV}* )
	processviewer? ( >=x11-misc/qps-2.9 )
	screenshot? ( >=x11-misc/screengrab-2.8 )
	sddm? ( x11-misc/sddm )
	ssh-askpass? ( =lxqt-base/lxqt-openssh-askpass-${MY_PV}* )
	sudo? ( =lxqt-base/lxqt-sudo-${MY_PV}* )
	terminal? ( =x11-terms/qterminal-${MY_PV}* )
	trash? ( gnome-base/gvfs )
	window-manager? (
		kde-plasma/kwin:6
		kde-plasma/systemsettings:6
	)
"
