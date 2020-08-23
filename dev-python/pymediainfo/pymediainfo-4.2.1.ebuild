# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
PYTHON_REQ_USE="xml(+)"
# The package uses pkg_resources to determine its version
DISTUTILS_USE_SETUPTOOLS=manual

inherit distutils-r1

DESCRIPTION="A wrapper around the mediainfo library"
HOMEPAGE="https://github.com/sbraz/pymediainfo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	media-libs/libmediainfo
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/alabaster
distutils_enable_tests pytest

python_prepare_all() {
	# Disable a test which requires network access
	sed -i 's/def test_parse_url/def _test_parse_url/' \
		tests/test_pymediainfo.py || die
	distutils-r1_python_prepare_all
}
