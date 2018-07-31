# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )

DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Bytecode optimisation using staticness assertions"
HOMEPAGE="https://github.com/rfk/promise/ https://pypi.org/project/promise/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="${PYTHON_DEPS}"

python_test() {
        nosetests -v || die
}
