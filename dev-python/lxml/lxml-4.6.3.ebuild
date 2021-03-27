# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1 optfeature toolchain-funcs

DESCRIPTION="A Pythonic binding for the libxml2 and libxslt libraries"
HOMEPAGE="https://lxml.de/ https://pypi.org/project/lxml/ https://github.com/lxml/lxml"
SRC_URI="https://github.com/lxml/lxml/archive/${P}.tar.gz"
S=${WORKDIR}/lxml-${P}

LICENSE="BSD ElementTree GPL-2 PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples +threads test"
RESTRICT="!test? ( test )"

# Note: lib{xml2,xslt} are used as C libraries, not Python modules.
RDEPEND="
	>=dev-libs/libxml2-2.9.5
	>=dev-libs/libxslt-1.1.28"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		$(python_gen_any_dep '
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
		')
	)
	test? ( dev-python/cssselect[${PYTHON_USEDEP}] )
	"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.0-tests-pypy.patch
)

python_check_deps() {
	use doc || return 0
	has_version "dev-python/docutils[${PYTHON_USEDEP}]" &&
	has_version "dev-python/pygments[${PYTHON_USEDEP}]" &&
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	has_version "dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	# avoid replacing PYTHONPATH in tests.
	sed -i -e '/sys\.path/d' test.py || die

	# don't use some random SDK on Darwin
	sed -i -e '/_ldflags =/s/=.*isysroot.*darwin.*None/= None/' \
		setupinfo.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	if ! python_is_python3; then
		local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	fi
	tc-export PKG_CONFIG
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake html
}

python_test() {
	cp -r -l src/lxml/tests "${BUILD_DIR}"/lib/lxml/ || die
	cp -r -l src/lxml/html/tests "${BUILD_DIR}"/lib/lxml/html/ || die
	ln -s "${S}"/doc "${BUILD_DIR}"/ || die

	"${EPYTHON}" test.py -vv --all-levels -p || die "Test ${test} fails with ${EPYTHON}"
}

python_install_all() {
	if use doc; then
		local DOCS=( README.rst *.txt doc/*.txt )
		local HTML_DOCS=( doc/html/. )
	fi
	if use examples; then
		dodoc -r samples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Support for BeautifulSoup as a parser backend" dev-python/beautifulsoup
	optfeature "Translates CSS selectors to XPath 1.0 expressions" dev-python/cssselect
}
