# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A dockerized approach to test a Gentoo package within a clean stage3 container"
HOMEPAGE="http://ebuildtester.readthedocs.io/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emulation/docker
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install
	newbashcomp "${FILESDIR}/${PN}.bash-completion" "${PN}"
}
