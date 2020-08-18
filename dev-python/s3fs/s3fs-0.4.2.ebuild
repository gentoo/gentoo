# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Pythonic file interface to S3"
HOMEPAGE="https://s3fs.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/botocore[${PYTHON_USEDEP}]
	dev-python/fsspec[${PYTHON_USEDEP}]"

BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/moto[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

src_prepare() {
	# requires internet access
	sed -e 's:test_anonymous_access:_&:' \
		-i s3fs/tests/test_s3fs.py || die

	distutils-r1_src_prepare
}
