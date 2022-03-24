# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A dockerized approach to test a Gentoo package within a clean stage3 container"
HOMEPAGE="https://ebuildtester.readthedocs.io/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-containers/docker
	sys-fs/fuse
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	newbashcomp "${FILESDIR}/${PN}.bash-completion" "${PN}"
}
