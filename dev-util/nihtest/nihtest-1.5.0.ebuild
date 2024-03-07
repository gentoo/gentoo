# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A testing tool for command line utilities"
HOMEPAGE="
	https://nih.at/nihtest/
	https://github.com/nih-at/nihtest
	https://pypi.org/project/nihtest/
"
SRC_URI+="
	https://nih.at/nihtest/${P}.tar.gz
	https://github.com/nih-at/nihtest/releases/download/v${PV}/${P}.tar.gz
"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/python-dateutil[${PYTHON_USEDEP}]')
"

DOCS=( NEWS.md README.md TODO.md )

src_install() {
	distutils-r1_src_install
	newman manpages/nihtest.man nihtest.1
	newman manpages/nihtest.conf.man nihtest.conf.5
	newman manpages/nihtest-case.man nihtest-case.5
}
