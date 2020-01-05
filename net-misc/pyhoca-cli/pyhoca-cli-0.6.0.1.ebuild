# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="X2Go command line client"
HOMEPAGE="http://www.x2go.org"
SRC_URI="http://code.x2go.org/releases/source/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setproctitle[${PYTHON_USEDEP}]
	>=net-misc/python-x2go-0.6.0.1[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install() {
	distutils-r1_python_install
	python_doscript ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	doman man/man1/*
	find "${ED}" -name '*.pth' -delete || die
}
