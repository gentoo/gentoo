# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{2_{5,6,7},3_{3,4,5,6}} )

inherit distutils-r1

DESCRIPTION="A dot-accessible dictionary (a la JavaScript objects)"
HOMEPAGE="https://github.com/Infinidat/munch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm64 ~x86"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
