# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
inherit python-single-r1

MY_PN="Caja-hide"

DESCRIPTION="Hide files without renaming them in MATE's Caja"
HOMEPAGE="https://github.com/Fred-Barclay/Caja-hide"
SRC_URI="https://github.com/Fred-Barclay/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep 'dev-python/future[${PYTHON_MULTI_USEDEP}]')
	dev-python/python-caja[${PYTHON_SINGLE_USEDEP}]
	x11-misc/xautomation
"
BDEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-py3-support.patch"
)

src_install() {
	insinto /usr/share/caja-python/extensions
	doins src/caja-hide.py
}
