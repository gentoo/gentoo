# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Compiz Reloaded (meta)"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="boxmenu +ccsm debugutils +emerald full +fusionicon manager simpleccsm"

RDEPEND="
	>=x11-plugins/compiz-plugins-meta-${PV}
	boxmenu? ( >=x11-apps/compiz-boxmenu-${PV} )
	ccsm? ( >=x11-misc/ccsm-${PV} )
	debugutils? ( >=x11-misc/compiz-debug-utils-${PV} )
	emerald? ( >=x11-wm/emerald-${PV} )
	full? (
		x11-plugins/compiz-plugins-meta[community,compicc,experimental,extra,extra-snowflake-textures]
		x11-wm/compiz[compizconfig]
	)
	fusionicon? ( >=x11-apps/fusion-icon-${PV} )
	manager? ( >=x11-apps/compiz-manager-${PV} )
	simpleccsm? ( >=x11-misc/simple-ccsm-${PV} )
"
REQUIRED_USE="full? ( boxmenu ccsm debugutils emerald fusionicon manager simpleccsm )"
