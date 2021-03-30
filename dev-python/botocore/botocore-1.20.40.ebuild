# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Low-level, data-driven core of boto 3"
HOMEPAGE="https://github.com/boto/botocore"
LICENSE="Apache-2.0"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/boto/botocore"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
fi

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.4[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/1.8.6-tests-pass-all-env-vars-to-cmd-runner.patch"
)

distutils_enable_sphinx docs/source \
	'dev-python/guzzle_sphinx_theme'
distutils_enable_tests nose

src_prepare() {
	# unpin deps
	sed -i -e "s:>=.*':':" setup.py || die
	# very unstable
	sed -i -e 's:test_stress_test_token_bucket:_&:' \
		tests/functional/retries/test_bucket.py || die
	distutils-r1_src_prepare
}

python_test() {
	# note: suites need to be run separately as one of the unit tests
	# seems to be leaking mocks and breaking a few functional tests
	nosetests -v tests/unit ||
		die "unit tests failed under ${EPYTHON}"
	nosetests -v tests/functional ||
		die "functional tests failed under ${EPYTHON}"
}
