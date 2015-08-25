# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib multilib qmake-utils

DESCRIPTION="A library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
SRC_URI="mirror://github/flavio/qjson/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug doc test"

RDEPEND=">=dev-qt/qtcore-4.8.6:4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( >=dev-qt/qttest-4.8.6:4[${MULTILIB_USEDEP}] )"

DOCS=( ChangeLog README.md )

multilib_src_configure() {
	local mycmakeargs=(
		-DQT_QMAKE_EXECUTABLE="$(qt4_get_bindir)/qmake"
		$(cmake-utils_use test QJSON_BUILD_TESTS)
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

	use doc && if is_final_abi; then
		cd "${S}"/doc || die
		doxygen Doxyfile || die
	fi
}

multilib_src_install_all() {
	if use doc; then
		HTML_DOCS=( doc/html/ )
		einstalldocs
	fi
}
