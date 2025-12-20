# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 optfeature toolchain-funcs

DESCRIPTION="A Pythonic binding for the libxml2 and libxslt libraries"
HOMEPAGE="
	https://lxml.de/
	https://pypi.org/project/lxml/
	https://github.com/lxml/lxml/
"
SRC_URI="
	https://github.com/lxml/lxml/archive/${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/lxml-${P}

LICENSE="BSD ElementTree GPL-2 PSF-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="doc examples +threads test"
RESTRICT="!test? ( test )"

# Note: lib{xml2,xslt} are used as C libraries, not Python modules.
DEPEND="
	>=dev-libs/libxml2-2.10.3:=
	>=dev-libs/libxslt-1.1.38
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	>=dev-python/cython-3.1.4[${PYTHON_USEDEP}]
	doc? (
		$(python_gen_any_dep '
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
	test? (
		dev-python/cssselect[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-6.0.0-pypy.patch"
)

python_check_deps() {
	use doc || return 0
	python_has_version -b "dev-python/docutils[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/pygments[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

python_prepare_all() {
	# don't use some random SDK on Darwin
	sed -i -e '/_ldflags =/s/=.*isysroot.*darwin.*None/= None/' \
		setupinfo.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local DISTUTILS_ARGS=(
		# by default it adds -w to CFLAGS
		--warnings
	)
	tc-export PKG_CONFIG
	distutils-r1_python_compile
}

python_compile_all() {
	# disable automagic dep on coverage
	use doc && emake CYTHON_WITH_COVERAGE= html
}

python_test() {
	local dir=${BUILD_DIR}/test$(python_get_sitedir)/lxml
	local -x PATH=${BUILD_DIR}/test/usr/bin:${PATH}

	cp -al "${BUILD_DIR}"/{install,test} || die
	cp -al src/lxml/tests "${dir}/" || die
	cp -al src/lxml/html/tests "${dir}/html/" || die
	mkdir "${dir}"/../../doc || die
	# this one needs to be copied, because upstream uses doc/../../../doc
	cp -r "${S}"/doc "${dir}"/../../ || die
	ln -s "${S}"/doc "${dir}"/../../../../ || die

	"${EPYTHON}" test.py --no-src -vv --all-levels -p ||
		die "Tests fail on ${EPYTHON}"
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
	optfeature "Support for BeautifulSoup as a parser backend" dev-python/beautifulsoup4
	optfeature "Translates CSS selectors to XPath 1.0 expressions" dev-python/cssselect
	optfeature "Support for lxml.html.clean sanitizer" dev-python/lxml-html-clean
}
