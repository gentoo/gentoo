# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python style guide checker (fka pep8)"
HOMEPAGE="
	https://pycodestyle.pycqa.org/en/latest/
	https://github.com/PyCQA/pycodestyle/
	https://pypi.org/project/pycodestyle/
"
# 2.11.0 broke sdist
# https://github.com/PyCQA/pycodestyle/issues/1183
SRC_URI="
	https://github.com/PyCQA/pycodestyle/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
