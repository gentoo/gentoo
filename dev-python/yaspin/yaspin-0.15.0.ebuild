# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7,8} pypy{,3} )
inherit distutils-r1

DESCRIPTION="A lightweight terminal spinner for Python with safe pipes and redirects"
HOMEPAGE="https://github.com/pavdmyt/yaspin https://pypi.org/project/yaspin/"
SRC_URI="https://github.com/pavdmyt/yaspin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
