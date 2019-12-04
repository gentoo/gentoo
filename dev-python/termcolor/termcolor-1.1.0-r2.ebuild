# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7,8}} pypy{,3} )

inherit distutils-r1

DESCRIPTION="ANSII Color formatting for output in terminal"
HOMEPAGE="https://pypi.org/project/termcolor/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86 ~amd64-linux ~x86-linux"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# no tests...
RESTRICT="test"
