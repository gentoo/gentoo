# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Configuration manager in your pocket"
HOMEPAGE="https://kaptan.readthedocs.io/"

SRC_URI="https://github.com/emre/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	esetup.py test
}
