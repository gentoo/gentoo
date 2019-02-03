# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{4,5,6,7}} )

inherit distutils-r1

MY_PN="${PN#python-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Library for parsing the fastimport VCS serialization format"
HOMEPAGE="https://github.com/jelmer/python-fastimport"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_test() {
	"${EPYTHON}" -m unittest -v fastimport.tests.test_suite \
		|| die "Tests fail with ${EPYTHON}"
}
