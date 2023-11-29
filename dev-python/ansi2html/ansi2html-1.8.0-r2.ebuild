# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Convert text with ANSI color codes to HTML"
HOMEPAGE="
	https://pypi.org/project/ansi2html/
	https://github.com/pycontribs/ansi2html/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~riscv x86"

RDEPEND="
	>=dev-python/six-1.7.3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_install_all() {
	doman man/${PN}.1
	distutils-r1_python_install_all
}
