# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
inherit cmake flag-o-matic wxwidgets

MY_PN="iacfleet_pi"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nohal/${MY_PN}.git"
else
	SRC_URI="https://github.com/nohal/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="IAC Fleetcode Plugin for OpenCPN"
HOMEPAGE="https://github.com/nohal/iacfleet_pi"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}
	sci-geosciences/opencpn:="
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/927485
	# https://github.com/nohal/iacfleet_pi/issues/30
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	setup-wxwidgets unicode
	cmake_src_configure
}
