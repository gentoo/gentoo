# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="Symbolic constants in Python"
HOMEPAGE="https://github.com/twisted/constantly https://pypi.org/project/constantly/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

#S=${WORKDIR}/${P}
