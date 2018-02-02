# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator

DESCRIPTION="Meta ebuild for LXQt, the Lightweight Desktop Environment"
HOMEPAGE="http://lxqt.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+about admin +filemanager lightdm lximage l10n minimal +policykit
	powermanagement sddm ssh-askpass sudo"

MY_PV="$(get_version_component_range 1-2)*"

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
	about? ( =lxqt-base/lxqt-about-${MY_PV} )
	admin? ( =lxqt-base/lxqt-admin-${MY_PV} )
	filemanager? ( =x11-misc/pcmanfm-qt-${MY_PV} )
	lightdm? ( x11-misc/lightdm )
	lximage? ( media-gfx/lximage-qt )
	l10n? ( =lxqt-base/lxqt-l10n-${MY_PV} )
	!minimal? (
		x11-wm/openbox
		x11-misc/obconf-qt
	)
	policykit? (
		=lxqt-base/lxqt-policykit-${MY_PV}
		|| (
			sys-auth/consolekit[policykit(-)]
			sys-apps/systemd[policykit(-)]
		)
	)
	powermanagement? ( =lxqt-base/lxqt-powermanagement-${MY_PV} )
	sddm? ( >=x11-misc/sddm-0.11.0 )
	ssh-askpass? ( =lxqt-base/lxqt-openssh-askpass-${MY_PV} )
	sudo? ( =lxqt-base/lxqt-sudo-${MY_PV} )
"

S="${WORKDIR}"
