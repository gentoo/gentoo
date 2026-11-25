# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
inherit meson distutils-r1

DESCRIPTION="The HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://codeberg.org/gumbo-parser/gumbo-parser"
SRC_URI="https://codeberg.org/grisha/gumbo-parser/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/gumbo-parser"

LICENSE="Apache-2.0"
SLOT="0/4" # gumbo SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="doc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="test? ( ${PYTHON_DEPS} )"
DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="
	doc? ( app-text/doxygen )
	test? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		$(python_gen_cond_dep 'dev-python/beautifulsoup4[${PYTHON_USEDEP}]')
	)
"

distutils_enable_tests unittest

pkg_setup() {
	use test && python-single-r1_pkg_setup
}

src_prepare() {
	default

	use test && distutils-r1_src_prepare
}

src_configure() {
	# -Dpython= controls whether meson should install the python module
	# Which right now has issues over the location of libgumbo.so without
	# duplicating it into each /site-packages/gumbo/
	# (low-priority issue, no known consumer)
	local emesonargs=(
		$(meson_use test tests)
		-Ddefault_library=shared
		-Dpython=false
	)

	meson_src_configure

	use test && distutils-r1_src_configure
}

src_compile() {
	meson_src_compile

	if use test; then
		# So the python tests can find the libgumbo.so which just got built
		ln -s "${BUILD_DIR}/libgumbo.so" "${S}/python/gumbo/libgumbo.so" || die

		distutils-r1_src_compile
	fi

	if use doc; then
		doxygen || die "doxygen failed"
		HTML_DOCS=( docs/html/. )
	fi
}

python_test() {
	pushd python/gumbo >/dev/null || die

	eunittest -p '*_test.py'

	popd >/dev/null
}

src_test() {
	meson_src_test
	distutils-r1_src_test
}

src_install() {
	meson_src_install

	use doc && doman docs/man/man3/*
}
