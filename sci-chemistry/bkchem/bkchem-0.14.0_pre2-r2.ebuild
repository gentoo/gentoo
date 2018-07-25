# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

PYTHON_REQ_USE="tk"

inherit distutils-r1 eutils versionator

MY_P="${PN}-$(replace_version_separator 3 -)"

DESCRIPTION="Chemical drawing program"
HOMEPAGE="http://bkchem.zirael.org/"
SRC_URI="http://bkchem.zirael.org/download/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE="cairo"

DEPEND="cairo? ( dev-python/pycairo[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-nolauncher.patch
)

python_install() {
	distutils-r1_python_install "--strip=${ED}/_${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	python_foreach_impl python_newscript ${PN}/${PN}.py ${PN}
	make_desktop_entry bkchem BKChem "${EPREFIX}"/usr/share/${PN}/images/${PN}.png Science
}
