# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 prefix

DESCRIPTION="Python interface to lzo"
HOMEPAGE="https://github.com/jd-boyd/python-lzo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/lzo:2"
DEPEND="${RDEPEND}"

# We can't use pytest at the moment because the package uses "yield tests"
# https://docs.pytest.org/en/6.2.x/deprecations.html#yield-tests
distutils_enable_tests --install nose

PATCHES=(
	# Upstream commits: 52440984, e63333e5, 15c40595 and 0a4272fc
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

python_prepare_all() {
	hprefixify setup.py
	distutils-r1_python_prepare_all
}
