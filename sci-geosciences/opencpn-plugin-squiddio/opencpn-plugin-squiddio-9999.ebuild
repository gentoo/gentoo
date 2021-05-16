# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit cmake wxwidgets

MY_PN="squiddio_pi"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mauroc/${MY_PN}.git"
else
	SRC_URI="https://github.com/mauroc/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Squiddio Plugin for OpenCPN"
HOMEPAGE="https://github.com/mauroc/squiddio_pi"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	>=sci-geosciences/opencpn-4.2.0
	sys-devel/gettext"
DEPEND="${RDEPEND}"
BDEPEND="
	net-misc/curl
	sys-devel/gettext"

src_configure() {
	setup-wxwidgets unicode
	cmake_src_configure
}
