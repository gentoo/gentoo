# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxde-meta/lxde-meta-0.5.5-r4.ebuild,v 1.5 2015/03/14 13:08:20 hwoarang Exp $

EAPI="2"

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.sf.net/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ppc x86"
IUSE=""

RDEPEND=">=lxde-base/menu-cache-0.3.3
	=lxde-base/lxappearance-0.5*
	=lxde-base/lxde-icon-theme-0.5*
	=lxde-base/lxde-common-0.5.5*
	=lxde-base/lxmenu-data-0.1*
	=lxde-base/lxinput-0.3*
	>=lxde-base/lxpanel-0.5.10
	=lxde-base/lxrandr-0.1*
	|| ( ( <=lxde-base/lxsession-0.4.6.1
		=lxde-base/lxsession-edit-0.2* )
		>lxde-base/lxsession-0.4.6.1 )
	|| ( >=x11-libs/libfm-1.2.0 =lxde-base/lxshortcut-0.1* )
	=lxde-base/lxtask-0.1*
	>=lxde-base/lxterminal-0.1.11
	media-gfx/gpicview
	x11-misc/pcmanfm
	x11-wm/openbox
	>=x11-misc/obconf-2.0.3_p20111019"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "http://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
