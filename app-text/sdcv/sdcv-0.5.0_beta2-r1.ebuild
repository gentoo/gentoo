# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="cs fr ru sk uk zh_CN zh_TW"
: ${CMAKE_MAKEFILE_GENERATOR:="ninja"}

inherit cmake-utils l10n

DESCRIPTION="Console version of Stardict program"
HOMEPAGE="http://sdcv.sourceforge.net"
MY_PV="${PV/_beta/-beta}-Source"
MY_PF="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_PF}"
SRC_URI="mirror://sourceforge/${PN}/${MY_PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="darkterm nls"

RDEPEND="sys-libs/zlib
	sys-libs/readline:=
	>=dev-libs/glib-2.6.1"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.14.1 )"

src_prepare() {
	if use darkterm; then
		sed -i 's/;34m/;36m/' src/libwrapper.cpp || die
	fi

	rm_loc() {
		rm "po/${1}.po" || die
	}
	l10n_for_each_disabled_locale_do rm_loc

	# do not install locale-specific man pages unless asked to
	if ! use linguas_uk; then
		sed -ni '/share\/man\/uk/!p' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_NLS="$(usex nls)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use nls && cmake-utils_src_compile lang
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS NEWS
}
