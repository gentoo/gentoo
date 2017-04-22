# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1

DESCRIPTION="Adds color to arbitrary command output"
HOMEPAGE="https://nojhan.github.com/colout/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	#PyPi tarball has wrong (old, evidently) README. Upstream uses GPL-3.
	sed -e 's:BSD licensed:GPL-3 licensed:' -i README || die
	distutils-r1_src_prepare
}
