# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1 multiprocessing

DESCRIPTION="A Python framework to generate language parsers"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll-bindings[iconv,shared,static-libs]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/funcy[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-ada/e3-core[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gnarl.patch
)

src_prepare() {
	default
	cd testsuite/tests

	# missing gprbuild option to build libraries static/relocatable
	rm -r {langkit_support,adalog,misc/link_two_libs} || die

	# require railroad-diagrams
	rm -r contrib/svg_railroad_diagrams || die
}

src_compile() {
	gprbuild -v -P support/langkit_support.gpr -p -j$(makeopts_jobs) \
		-XBUILD_MODE=dev -XLIBRARY_TYPE=relocatable -cargs:Ada ${ADAFLAGS} \
		|| die
	distutils-r1_src_compile
}

src_test() {
	${EPYTHON} ./manage.py make --no-langkit-support || die
	eval $(./manage.py setenv)
	${EPYTHON} ./manage.py test --verbose |& tee langkit.testOut
	grep -qw FAIL langkit.testOut && die
}

src_install() {
	gprinstall -v -P support/langkit_support.gpr -p -XBUILD_MODE=dev \
		--prefix="${D}"/usr --build-var=LIBRARY_TYPE \
		--build-var=LANGKIT_SUPPORT_LIBRARY_TYPE \
		--sources-subdir=include/langkit_support \
		-XLIBRARY_TYPE=relocatable --build-name=relocatable || die
	distutils-r1_src_install
}
