# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="$(ver_cut 1-2)*"

DESCRIPTION="Meta ebuild for LXQt, the Lightweight Desktop Environment"
HOMEPAGE="https://lxqt.org/"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="metapackage"
SLOT="0"
IUSE="+about admin +filemanager lightdm lximage minimal nls
	+policykit powermanagement processviewer screenshot sddm
	ssh-askpass sudo terminal"

# Note: we prefer kde-frameworks/oxygen-icons over other icon sets, as the initial
# install expects oxygen icons, until the user specifies otherwise (bug 543380)
RDEPEND="
	kde-frameworks/oxygen-icons
	>=lxde-base/lxmenu-data-0.1.5
	=lxqt-base/lxqt-config-${MY_PV}
	=lxqt-base/lxqt-globalkeys-${MY_PV}
	=lxqt-base/lxqt-notificationd-${MY_PV}
	=lxqt-base/lxqt-panel-${MY_PV}
	=lxqt-base/lxqt-qtplugin-${MY_PV}
	=lxqt-base/lxqt-runner-${MY_PV}
	=lxqt-base/lxqt-session-${MY_PV}
	virtual/ttf-fonts
	=x11-themes/lxqt-themes-${MY_PV}
	about? ( =lxqt-base/lxqt-about-${MY_PV} )
	admin? ( =lxqt-base/lxqt-admin-${MY_PV} )
	filemanager? ( =x11-misc/pcmanfm-qt-${MY_PV} )
	lightdm? ( x11-misc/lightdm )
	lximage? ( media-gfx/lximage-qt )
	!minimal? (
		x11-wm/openbox
		x11-misc/obconf-qt
	)
	nls? ( dev-qt/qttranslations:5 )
	policykit? ( =lxqt-base/lxqt-policykit-${MY_PV} )
	powermanagement? ( =lxqt-base/lxqt-powermanagement-${MY_PV} )
	processviewer? ( x11-misc/qps:0 )
	screenshot? ( x11-misc/screengrab:0 )
	sddm? ( >=x11-misc/sddm-0.11.0 )
	ssh-askpass? ( =lxqt-base/lxqt-openssh-askpass-${MY_PV} )
	sudo? ( =lxqt-base/lxqt-sudo-${MY_PV} )
	terminal? ( x11-terms/qterminal:0 )
"
