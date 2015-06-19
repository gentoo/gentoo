# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-fastimport/python-fastimport-0.9.2-r1.ebuild,v 1.5 2015/05/27 11:25:50 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Library for parsing the fastimport VCS serialization format"
HOMEPAGE="https://launchpad.net/python-fastimport"
SRC_URI="http://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? (
		dev-python/testtools[${PYTHON_USEDEP}]
	)"

python_test() {
	local test_runner=( "${PYTHON}" -m unittest )

	if [[ ${EPYTHON} == python2.6 ]]; then
		test_runner=( unit2 )
	fi

	"${test_runner[@]}" fastimport.tests.test_suite \
		|| die "Tests fail with ${EPYTHON}"
}
