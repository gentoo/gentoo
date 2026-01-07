# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Library for parsing the fastimport VCS serialization format"
HOMEPAGE="
	https://github.com/jelmer/python-fastimport/
	https://pypi.org/project/fastimport/
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 x86 ~x64-macos ~x64-solaris"

python_test() {
	"${EPYTHON}" -m unittest -v fastimport.tests.test_suite ||
		die "Tests fail with ${EPYTHON}"
}
