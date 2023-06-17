# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9,10,11} )

inherit bash-completion-r1 distutils-r1 pypi

DESCRIPTION="A dockerized approach to test a Gentoo package within a clean stage3 container"
HOMEPAGE="https://ebuildtester.readthedocs.io/"

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
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	newbashcomp "${PN}.bash-completion" "${PN}"
}
