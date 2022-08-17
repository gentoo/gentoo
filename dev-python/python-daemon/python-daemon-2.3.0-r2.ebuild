# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Library to implement a well-behaved Unix daemon process"
HOMEPAGE="https://pypi.org/project/python-daemon/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm x86"

RDEPEND="
	dev-python/lockfile[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/twine[${PYTHON_USEDEP}]
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/testscenarios[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

distutils_enable_tests unittest

src_prepare() {
	# fix for >=testtools-2.5.0
	sed -e 's/testtools.helpers.safe_hasattr/hasattr/' \
		-i test/test_metadata.py || die
	distutils-r1_src_prepare
}
