# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="Cheetah3"
MY_P="${MY_PN}-${PV/_}"

DESCRIPTION="Python-powered template engine and code generator"
HOMEPAGE="http://www.cheetahtemplate.org/ https://pypi.org/project/Cheetah3/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
IUSE=""
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="dev-python/markdown[${PYTHON_USEDEP}]
	!dev-python/cheetah"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

DOCS=( ANNOUNCE.rst README.rst TODO )
# Race in the test suite
DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Disable broken tests.
	sed \
		-e "/Unicode/d" \
		-e "s/if not sys.platform.startswith('java'):/if False:/" \
		-e "/results =/a\\    sys.exit(not results.wasSuccessful())" \
		-i Cheetah/Tests/Test.py || die "sed failed"

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" Cheetah/Tests/Test.py || die "Testing failed with ${EPYTHON}"
}
