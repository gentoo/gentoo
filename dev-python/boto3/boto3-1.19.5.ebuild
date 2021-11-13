# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="The AWS SDK for Python"
HOMEPAGE="https://github.com/boto/boto3"
LICENSE="Apache-2.0"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/boto/boto3"
	inherit git-r3
	BOTOCORE_PV=${PV}
else
	SRC_URI="https://github.com/boto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

	# botocore is x.(y+3).z
	BOTOCORE_PV="$(ver_cut 1).$(( $(ver_cut 2) + 3)).$(ver_cut 3-)"
fi

RDEPEND="
	<dev-python/botocore-1.23[${PYTHON_USEDEP}]
	>=dev-python/botocore-${BOTOCORE_PV}[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source \
	'dev-python/guzzle_sphinx_theme'
distutils_enable_tests pytest

python_prepare_all() {
	# don't lock versions to narrow ranges
	sed -e '/botocore/ d' \
		-e '/jmespath/ d' \
		-e '/s3transfer/ d' \
		-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	epytest tests/{functional,unit}
}
