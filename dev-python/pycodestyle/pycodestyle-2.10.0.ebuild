# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python style guide checker (fka pep8)"
HOMEPAGE="
	https://pycodestyle.pycqa.org/en/latest/
	https://github.com/PyCQA/pycodestyle/
	https://pypi.org/project/pycodestyle/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme

python_test() {
	local -x PYTHONPATH=${S}
	"${EPYTHON}" pycodestyle.py -v --statistics pycodestyle.py || die "Tests failed with ${EPYTHON}"
	"${EPYTHON}" pycodestyle.py -v --max-doc-length=72 --testsuite=testsuite || die "Tests failed with ${EPYTHON}"
	"${EPYTHON}" pycodestyle.py --doctest -v || die "Tests failed with ${EPYTHON}"
}
