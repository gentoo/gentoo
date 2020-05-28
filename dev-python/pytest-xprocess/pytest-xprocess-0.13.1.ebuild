# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage external processes across test runs"
HOMEPAGE="https://pypi.org/project/pytest-xprocess/ https://github.com/pytest-dev/pytest-xprocess"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
