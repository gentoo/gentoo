# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

MY_PN="climatology_pi"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rgleason/${MY_PN}.git"
else
	SRC_URI="https://github.com/rgleason/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Climatology Plugin for OpenCPN (includes CL-DATA)"
HOMEPAGE="https://github.com/rgleason/climatology_pi"
SRC_URI="
	${SRC_URI}
	mirror://sourceforge/opencpnplugins/climatology_pi/CL-DATA-1.0.tar.xz -> ${PN}-1.0-CL-DATA.tar.xz"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	sci-geosciences/opencpn:="
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

src_unpack() {
	unpack ${A}
	if [[ ${PV} == *9999 ]] ; then
		git-r3_checkout
	fi
}

src_configure() {
	setup-wxwidgets unicode
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/opencpn/plugins/${MY_PN}/data/
	doins -r {,../}data/.
}
