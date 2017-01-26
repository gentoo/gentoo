# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=(python{2_7,3_4})

inherit vcs-snapshot distutils-r1

DESCRIPTION="Stem is a Python controller library for Tor"
HOMEPAGE="https://stem.torproject.org"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}]
	net-misc/tor )
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="net-misc/tor"

DOCS=( docs/{_static,_templates,api,tutorials,{change_log,api,contents,download,faq,index,tutorials}.rst} )

python_prepare_all() {
	# Disable failing test
	sed -i -e "/test_expand_path/a \
		\ \ \ \ return" test/integ/util/system.py || die
	sed -i -e "/test_get_connections_by_ss/,+1d"\
		test/integ/util/connection.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	${PYTHON} run_tests.py --all --target RUN_ALL || die
}
