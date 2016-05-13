# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Console version of Stardict program"
HOMEPAGE="http://sdcv.sourceforge.net"
MY_PV="${PV/_beta/-beta}-Source"
MY_PF="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_PF}"
SRC_URI="mirror://sourceforge/${PN}/${MY_PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="nls"

RDEPEND="sys-libs/zlib
	sys-libs/readline:=
	>=dev-libs/glib-2.6.1"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.14.1 )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with nls)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	cmake-utils_src_compile lang
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS NEWS
}
