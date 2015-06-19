# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-meta/lxqt-meta-0.7.0-r1.ebuild,v 1.4 2015/02/10 13:27:58 yngwin Exp $

EAPI=5

inherit readme.gentoo

DESCRIPTION="Meta ebuild for LXQt, the Lightweight Desktop Environment"
HOMEPAGE="http://lxqt.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+icons lightdm lximage -minimal +policykit powermanagement sddm ssh-askpass"

S="${WORKDIR}"

DOC_CONTENTS="
	For your convenience you can review
	http://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml and
	http://wiki.lxde.org/en/LXDE-Qt"

RDEPEND="
	>=lxde-base/lxmenu-data-0.1.2
	~lxqt-base/lxqt-about-${PV}
	~lxqt-base/lxqt-common-${PV}
	~lxqt-base/lxqt-config-${PV}
	~lxqt-base/lxqt-config-randr-${PV}
	~lxqt-base/lxqt-notificationd-${PV}
	~lxqt-base/lxqt-panel-${PV}
	~lxqt-base/lxqt-qtplugin-${PV}
	~lxqt-base/lxqt-runner-${PV}
	~lxqt-base/lxqt-session-${PV}
	~x11-misc/pcmanfm-qt-${PV}
	icons? (
		>=lxde-base/lxde-icon-theme-0.5 )
	lightdm? (
		x11-misc/lightdm )
	lximage? (
		media-gfx/lximage-qt )
	!minimal? (
		x11-wm/openbox
		>=x11-misc/obconf-qt-0.1.0 )
	policykit? (
		~lxqt-base/lxqt-policykit-${PV}
		|| ( sys-auth/consolekit[policykit(-)]
			sys-apps/systemd[policykit(-)] ) )
	powermanagement? (
		~lxqt-base/lxqt-powermanagement-${PV} )
	sddm? (
		x11-misc/sddm )
	ssh-askpass? (
		~lxqt-base/lxqt-openssh-askpass-${PV} )
"

pkg_postinst() {
	readme.gentoo_pkg_postinst
}
