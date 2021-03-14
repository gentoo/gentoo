# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="https://wiki.lxde.org/en/Status_of_LXDE_components"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=lxde-base/menu-cache-1.1.0-r1
	>=lxde-base/lxappearance-0.6.3-r2
	>=lxde-base/lxde-icon-theme-0.5.1-r1
	>=lxde-base/lxde-common-0.99.2-r1
	>=lxde-base/lxmenu-data-0.1.5
	>=lxde-base/lxinput-0.3.5-r2
	>=lxde-base/lxpanel-0.10.1
	>=lxde-base/lxrandr-0.3.2-r1
	>=lxde-base/lxsession-0.5.5
	>=lxde-base/lxtask-0.1.10
	>=lxde-base/lxterminal-0.3.2-r1
	media-gfx/gpicview
	>=x11-libs/libfm-1.3.2
	>=x11-misc/obconf-2.0.4
	>=x11-misc/pcmanfm-1.3.2
	>=x11-wm/openbox-3.6.1-r3
"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "https://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
