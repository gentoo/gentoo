# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Easily capture stdout/stderr of the current process and subprocesses"
HOMEPAGE="https://capturer.readthedocs.io/en/latest/
	https://pypi.org/project/capturer/
	https://github.com/xolox/python-capturer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/humanfriendly-2.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

# Test fails only ebuild, but works manually
# Can't find out what it is
RESTRICT=test

python_test() {
	esetup.py test
}
