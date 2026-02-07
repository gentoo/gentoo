# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit bash-completion-r1 distutils-r1 pypi

DESCRIPTION="A dockerized approach to test a Gentoo package within a clean stage3 container"
HOMEPAGE="https://ebuildtester.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-containers/docker
	app-containers/docker-cli
	dev-python/platformdirs[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	sys-fs/fuse
"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme
distutils_enable_tests unittest

src_install() {
	distutils-r1_src_install
	newbashcomp "${PN}.bash-completion" "${PN}"
}
