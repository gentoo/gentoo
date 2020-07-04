# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Mock out responses from the requests package"
HOMEPAGE="https://github.com/jamielennox/requests-mock"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

RDEPEND="
	>=dev-python/requests-1.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc/source
distutils_enable_tests unittest

python_prepare_all() {
	# Disable reno which only works inside a git repository
	sed -i "s/'reno.sphinxext',//" doc/source/conf.py || die
	# Remove the release notes section which requires reno
	rm doc/source/release-notes.rst || die
	sed -i '/^=============$/,/release-notes/d' doc/source/index.rst || die
	# Disable a test which requires purl (not in the tree)
	sed -i -e "/^import purl$/d" -e "s/test_with_purl/_&/" \
		tests/test_adapter.py || die
	distutils-r1_python_prepare_all
}
