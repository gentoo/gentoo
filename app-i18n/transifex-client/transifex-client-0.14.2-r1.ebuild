# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A command line interface for Transifex"
HOMEPAGE="https://pypi.org/project/transifex-client/ https://www.transifex.net/ https://github.com/transifex/transifex-client"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/GitPython[${PYTHON_USEDEP}]
	<dev-python/python-slugify-5.0.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	<dev-python/six-2.0.0[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-0.14.2-r1-timestamp.patch"
)

distutils_enable_tests setup.py

src_prepare() {
	default

	sed -i -e 's:test_fetch_timestamp_from_git_tree:_&:' \
		tests/test_utils.py || die
	sed -i '/tests_require=\["mock>=3.0.5,<4.0"\]/d' setup.py || die
}
