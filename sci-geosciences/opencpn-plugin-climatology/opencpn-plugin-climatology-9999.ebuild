# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"
MY_PN="climatology_pi"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/seandepagnier/${MY_PN}.git"
	inherit git-r3 cmake-utils wxwidgets
	KEYWORDS=""
else
	SRC_URI="
		https://github.com/seandepagnier/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		mirror://sourceforge/opencpnplugins/climatology_pi/CL-DATA-1.0.tar.xz -> ${P}-CL-DATA.tar.xz
	"
	inherit cmake-utils wxwidgets
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Climatology Plugin for OpenCPN (includes CL-DATA)"
HOMEPAGE="https://github.com/seandepagnier/climatology_pi"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=sci-geosciences/opencpn-4.2.0
	sys-devel/gettext
"
DEPEND="${RDEPEND}"

src_prepare() {
	need-wxwidgets unicode
	cmake-utils_src_prepare
}
src_install() {
	cmake-utils_src_install
	insinto "/usr/share/opencpn/plugins/${MY_PN}/data/"
	doins "${S}"/{,../}data/*
}
