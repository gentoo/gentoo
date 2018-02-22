# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ppc x86"
IUSE=""

RDEPEND=">=lxde-base/menu-cache-0.3.3
	>=lxde-base/lxappearance-0.5.5
	>=lxde-base/lxde-icon-theme-0.5.0
	>=lxde-base/lxde-common-0.5.5
	>=lxde-base/lxmenu-data-0.1.4
	>=lxde-base/lxinput-0.3.2
	>=lxde-base/lxpanel-0.5.10
	>=lxde-base/lxrandr-0.1.2
	>=lxde-base/lxsession-0.5.2
	|| ( >=x11-libs/libfm-1.2.0 =lxde-base/lxshortcut-0.1* )
	>=lxde-base/lxtask-0.1.6
	>=lxde-base/lxterminal-0.1.11
	media-gfx/gpicview
	x11-misc/pcmanfm
	x11-wm/openbox
	>=x11-misc/obconf-2.0.3_p20111019"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "https://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
