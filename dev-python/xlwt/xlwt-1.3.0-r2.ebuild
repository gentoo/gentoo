# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python library to create spreadsheet files compatible with Excel"
HOMEPAGE="
	https://www.python-excel.org/
	https://github.com/python-excel/xlwt/
	https://pypi.org/project/xlwt/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="examples"

distutils_enable_sphinx docs \
	dev-python/pkginfo
distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}
	fi
	distutils-r1_python_install_all
}
