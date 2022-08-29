# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Python is used both for htmlreport (USE flag) but also for various
# helper scripts in /usr/share/cppcheck.
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 cmake

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="https://github.com/danmar/cppcheck/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="htmlreport pcre qt5 test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/tinyxml2:=
	htmlreport? (
		$(python_gen_cond_dep '
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	pcre? ( dev-libs/libpcre )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qthelp:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	htmlreport? ( ${DISTUTILS_DEPS} )
	qt5? ( dev-qt/linguist-tools:5 )
	test? (
		htmlreport? (
			$(python_gen_cond_dep 'dev-python/unittest-or-fail[${PYTHON_USEDEP}]')
		)
	)
"

src_prepare() {
	cmake_src_prepare

	distutils-r1_src_prepare
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	rm htmlreport/test_htmlreport.py || die
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_RULES="$(usex pcre)"
		-DBUILD_GUI="$(usex qt5)"
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

python_install() {
	if use htmlreport ; then
		pushd htmlreport || die
		distutils-r1_python_install
		popd || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	python_fix_shebang "${ED}"/usr/share/cppcheck/*
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}/cfg
	doins cfg/*.cfg

	if use qt5 ; then
		dobin "${WORKDIR}/${P}_build/bin/${PN}-gui"
		dodoc gui/{projectfile.txt,gui.${PN}}
	fi

	distutils-r1_src_install

	dodoc -r tools/triage
}
