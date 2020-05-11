# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="Python-powered template engine and code generator"
HOMEPAGE="http://www.cheetahtemplate.org/ https://pypi.org/project/Cheetah3/"
SRC_URI="https://github.com/CheetahTemplate3/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
IUSE=""
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
	!dev-python/cheetah
"
BDEPEND="${RDEPEND}"

DOCS=( ANNOUNCE.rst README.rst TODO )

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
	cp -r "${S}/Cheetah/Tests/ImportHooksTemplates" \
		"${BUILD_DIR}/lib/Cheetah/Tests/ImportHooksTemplates" || die

	"${EPYTHON}" Cheetah/Tests/Test.py || die "Tests fail with ${EPYTHON}"
}
