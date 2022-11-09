# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Convert text with ANSI color codes to HTML"
HOMEPAGE="https://pypi.org/project/ansi2html/
	https://github.com/pycontribs/ansi2html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm ~riscv x86"
IUSE=""

RDEPEND=">=dev-python/six-1.7.3[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install_all() {
	doman man/${PN}.1
	distutils-r1_python_install_all
}
