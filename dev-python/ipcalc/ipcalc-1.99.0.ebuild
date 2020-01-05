# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="IP subnet calculator"
HOMEPAGE="https://pypi.org/project/ipcalc/"
SRC_URI="https://github.com/tehmaze/${PN}/archive/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"
