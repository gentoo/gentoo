# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

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

distutils_enable_tests unittest

python_install_all() {
	dodoc docs/*.rst
	rm docs/*.rst || die
	local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
