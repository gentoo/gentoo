# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A command line interface for Transifex"
HOMEPAGE="https://pypi.org/project/transifex-client/ https://www.transifex.net/"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/GitPython[${PYTHON_USEDEP}]
	<dev-python/python-slugify-5.0.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	<dev-python/six-2.0.0[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py

src_prepare() {
	eapply_user
	sed -i -e 's:test_fetch_timestamp_from_git_tree:_&:' \
		tests/test_utils.py || die
}
