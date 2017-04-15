# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multibuild

DESCRIPTION="Library for mapping JSON data to QVariant objects"
HOMEPAGE="http://qjson.sourceforge.net"
SRC_URI="https://github.com/flavio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="debug doc +qt4 qt5 test"

RDEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
	)
"

DOCS=( ChangeLog README.md )

REQUIRED_USE="|| ( qt4 qt5 )"

PATCHES=(
	"${FILESDIR}/${P}-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-featuresummary.patch"
)

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	myconfigure() {
		if [[ ${MULTIBUILD_VARIANT} = qt4 ]]; then
			local mycmakeargs=(-DQT4_BUILD=ON)
		fi

		mycmakeargs+=(
			-DQJSON_BUILD_TESTS=$(usex test)
		)

		cmake-utils_src_configure
	}

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_test() {
	multibuild_foreach_variant cmake-utils_src_test
}

src_install() {
	if use doc; then
		pushd doc > /dev/null || die
			doxygen Doxyfile || die "Generating documentation failed"
			HTML_DOCS=( doc/html/. )
		popd > /dev/null || die
	fi

	multibuild_foreach_variant cmake-utils_src_install
}
