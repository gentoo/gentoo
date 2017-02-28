# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WX_GTK_VER="3.0"
MY_PN="gxradar_pi"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/trudK45/${MY_PN}.git"
	inherit git-r3 cmake-utils wxwidgets
	KEYWORDS=""
else
	SRC_URI="
		https://github.com/trudK45/${MY_PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz
	"
	inherit cmake-utils wxwidgets
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-v.${PV}"
fi

DESCRIPTION="Garmin xHD Radar Plugin for OpenCPN"
HOMEPAGE="https://github.com/trudK45/gxradar_pi"

LICENSE="GPL-2+"
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
