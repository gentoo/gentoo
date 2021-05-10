# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Library for parsing the fastimport VCS serialization format"
HOMEPAGE="https://github.com/jelmer/python-fastimport"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

python_test() {
	"${EPYTHON}" -m unittest -v fastimport.tests.test_suite ||
		die "Tests fail with ${EPYTHON}"
}
