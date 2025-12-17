# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
inherit meson distutils-r1

HTML5LIB_TESTS_COMMIT="a9f44960a9fedf265093d22b2aa3c7ca123727b9"

DESCRIPTION="The HTML5 parsing algorithm implemented as a pure C99 library"
HOMEPAGE="https://codeberg.org/gumbo-parser/gumbo-parser"
SRC_URI="
	https://codeberg.org/grisha/gumbo-parser/archive/${PV}.tar.gz -> ${P}.tar.gz
	test? (
		https://github.com/html5lib/html5lib-tests/archive/${HTML5LIB_TESTS_COMMIT}.tar.gz
		-> html5lib-tests-${HTML5LIB_TESTS_COMMIT}.tar.gz
	)
"
S="${WORKDIR}/gumbo-parser"

LICENSE="Apache-2.0"
SLOT="0/3" # gumbo SONAME
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

src_prepare() {
	default

	if use test; then
		rm -d "${S}/testdata" || die
		mv "${WORKDIR}/html5lib-tests-${HTML5LIB_TESTS_COMMIT}" "${S}/testdata" || die

		distutils-r1_src_prepare
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		-Ddefault_library=shared
	)

	meson_src_configure

	use test && distutils-r1_src_configure
}

src_compile() {
	meson_src_compile

	if use test; then
		# So the python tests can find the libgumbo.so which just got built
		ln -s "${BUILD_DIR}" "${S}/.libs" || die

		distutils-r1_src_compile
	fi

	if use doc; then
		doxygen || die "doxygen failed"
		HTML_DOCS=( docs/html/. )
	fi
}

python_test() {
	pushd python/gumbo >/dev/null || die

	# For some reason `unittest discover` seems to only run only a single test file
	# TODO: Change to *_test.py after https://codeberg.org/gumbo-parser/gumbo-parser/pulls/29
	for t in html5lib_adapter_test.py
	do
		set -- "${EPYTHON}" "$t"
		echo "$@" >&2
		"$@" || die "Tests failed with ${EPYTHON}"
	done

	popd >/dev/null
}

src_test() {
	meson_src_test
	distutils-r1_src_test
}

src_install() {
	meson_src_install

	use doc && doman docs/man/man3/*

	#>>> import gumbo
	#Traceback (most recent call last):
	#  File "<stdin>", line 1, in <module>
	#  File "/usr/lib/python3.12/site-packages/gumbo/__init__.py", line 33, in <module>
	#    from gumbo.gumboc import *
	#  File "/usr/lib/python3.12/site-packages/gumbo/gumboc.py", line 29, in <module>
	#    import gumboc_tags
	#ModuleNotFoundError: No module named 'gumboc_tags'
	#
	#use python && distutils-r1_src_install
}
