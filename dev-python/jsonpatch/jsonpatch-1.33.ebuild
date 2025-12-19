# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

MY_P=python-json-patch-${PV}
DESCRIPTION="Apply JSON-Patches like http://tools.ietf.org/html/draft-pbryan-json-patch-04"
HOMEPAGE="
	https://github.com/stefankoegl/python-json-patch/
	https://pypi.org/project/jsonpatch/
"
SRC_URI="
	https://github.com/stefankoegl/python-json-patch/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/jsonpointer-1.9[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# https://github.com/stefankoegl/python-json-patch/pull/159
	sed -e 's/unittest.makeSuite/unittest.defaultTestLoader.loadTestsFromTestCase/' \
		-i ext_tests.py tests.py
}

python_test() {
	"${EPYTHON}" tests.py || die "Tests of tests.py fail with ${EPYTHON}"
	"${EPYTHON}" ext_tests.py || die "Tests of ext_tests.py fail with ${EPYTHON}"
}
