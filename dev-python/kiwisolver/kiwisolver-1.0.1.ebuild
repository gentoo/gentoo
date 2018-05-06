# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="An efficient C++ implementation of the Cassowary constraint solving algorithm"
HOMEPAGE="https://github.com/nucleic/kiwi"
SRC_URI="https://github.com/nucleic/kiwi/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Clear-BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
S="${WORKDIR}"/kiwi-${PV}
