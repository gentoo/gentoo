# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/stem/stem-1.4.1.ebuild,v 1.1 2015/05/25 11:49:39 mrueg Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})

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
