# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Library for parsing the fastimport VCS serialization format"
HOMEPAGE="
	https://github.com/jelmer/python-fastimport/
	https://pypi.org/project/fastimport/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ppc ~ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

python_test() {
	"${EPYTHON}" -m unittest -v fastimport.tests.test_suite ||
		die "Tests fail with ${EPYTHON}"
}
