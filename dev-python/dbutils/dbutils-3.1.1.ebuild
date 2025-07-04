# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=DBUtils
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Database connections for multi-threaded environments"
HOMEPAGE="
	https://webwareforpython.github.io/DBUtils/
	https://github.com/WebwareForPython/DBUtils/
	https://pypi.org/project/DBUtils/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

python_install_all() {
	local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
