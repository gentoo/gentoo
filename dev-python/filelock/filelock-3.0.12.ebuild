# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )
inherit distutils-r1

MY_P=py-filelock-${PV}
DESCRIPTION="A platform independent file lock for Python"
HOMEPAGE="https://github.com/benediktschmitt/py-filelock
	https://pypi.org/project/filelock/"
SRC_URI="https://github.com/benediktschmitt/py-filelock/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
