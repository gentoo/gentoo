# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="An Amazon S3 Transfer Manager"
HOMEPAGE="https://github.com/boto/s3transfer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/botocore[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests nose

PATCHES=(
	"${FILESDIR}"/s3transfer-0.3.3-py38.patch
)

python_test() {
	nosetests -v tests/unit/ tests/functional/ || die "tests failed under ${EPYTHON}"
}
