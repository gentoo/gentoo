# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_SETUPTOOLS=manual
inherit distutils-r1 cmake

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="https://github.com/danmar/cppcheck/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ppc64 sparc x86"
IUSE="htmlreport pcre qt5 test +z3"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/tinyxml2:=
	htmlreport? (
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
	pcre? ( dev-libs/libpcre )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qthelp
		dev-qt/qtprintsupport:5
	)
	z3? ( sci-mathematics/z3 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
	test? (
		htmlreport? ( dev-python/unittest-or-fail[${PYTHON_USEDEP}] )
	)
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_RULES="$(usex pcre)"
		-DBUILD_GUI="$(usex qt5)"
		-DUSE_Z3="$(usex z3)"
		-DFILESDIR="${EPREFIX}/usr/share/${PN}/"
		-DENABLE_OSS_FUZZ=OFF
		-DUSE_BUNDLED_TINYXML2=OFF
		-DBUILD_TESTS="$(usex test)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use htmlreport ; then
		pushd htmlreport || die
		distutils-r1_src_compile
		popd || die
	fi
}

src_test() {
	cmake_src_test

	# TODO: Needs some hackery to find the right binary
	#if use htmlreport ; then
	#	distutils-r1_src_test
	#fi
}

python_test() {
	pushd htmlreport || die
	eunittest
	popd || die
}

src_install() {
	cmake_src_install

	insinto "/usr/share/${PN}/cfg"
	doins cfg/*.cfg

	if use qt5 ; then
		dobin "${WORKDIR}/${P}_build/bin/${PN}-gui"
		dodoc gui/{projectfile.txt,gui.${PN}}
	fi

	if use htmlreport ; then
		pushd htmlreport || die
		distutils-r1_src_install
		popd || die
	fi

	dodoc -r tools/triage
}
