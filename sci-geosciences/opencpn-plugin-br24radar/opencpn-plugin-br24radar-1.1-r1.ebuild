# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
inherit cmake-utils wxwidgets

MY_PN="BR24radar_pi"

DESCRIPTION="Navico (Simrad, Lowrance) Broadband BR24/3G/4G Radar Plugin for OpenCPN"
HOMEPAGE="http://opencpn-navico-radar-plugin.github.io/"
SRC_URI="
	https://github.com/canboat/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=sci-geosciences/opencpn-4.0.0
	<sci-geosciences/opencpn-4.2.0
	sys-devel/gettext
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	need-wxwidgets unicode
	cmake-utils_src_prepare
}
