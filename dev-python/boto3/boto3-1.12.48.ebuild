# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="The AWS SDK for Python"
HOMEPAGE="https://github.com/boto/boto3"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/boto/boto3"
	inherit git-r3
else
	SRC_URI="https://github.com/boto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
fi

RDEPEND="
	>=dev-python/botocore-1.15.48[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (	${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

RESTRICT="!test? ( test )"

distutils_enable_sphinx docs \
	'dev-python/guzzle_sphinx_theme'

python_prepare_all() {
	# don't lock versions to narrow ranges
	sed -e '/botocore/ d' \
		-e '/jmespath/ d' \
		-e '/s3transfer/ d' \
		-i setup.py || die

	# prevent an infinite loop
	rm tests/functional/docs/test_smoke.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v tests/unit/ tests/functional/ || die "test failed under ${EPYTHON}"
}
