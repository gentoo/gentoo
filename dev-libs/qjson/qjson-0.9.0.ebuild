# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
SRC_URI="https://github.com/flavio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug doc test"

RDEPEND="
	dev-qt/qtcore:4[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:4[${MULTILIB_USEDEP}] )
"

DOCS=( ChangeLog README.md )

PATCHES=(
	"${FILESDIR}/${P}-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-featuresummary.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DQT4_BUILD=ON
		-DQJSON_BUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	if use doc && is_final_abi; then
		pushd doc > /dev/null || die
			doxygen Doxyfile || die "Generating documentation failed"
			HTML_DOCS=( doc/html/. )
		popd > /dev/null || die
		einstalldocs
	fi
}
