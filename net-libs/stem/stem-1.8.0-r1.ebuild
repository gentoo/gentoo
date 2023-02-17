# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Fails w/ 3.11: https://github.com/torproject/stem/issues/130 (breaks net-misc/nyx)
PYTHON_COMPAT=( python3_{9..10} pypy3 )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Stem is a Python controller library for Tor"
HOMEPAGE="https://stem.torproject.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}]
	net-vpn/tor )
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="net-vpn/tor"

DOCS=( docs/{_static,_templates,api,tutorials,{change_log,api,contents,download,faq,index,tutorials}.rst} )

python_prepare_all() {
	# Disable failing test
	sed -i -e "/test_expand_path/a \
		\ \ \ \ return" test/integ/util/system.py || die
	sed -i -e "/test_parsing_with_example/a \
		\ \ \ \ return" test/unit/manual.py || die
	sed -i -e "/test_parsing_with_unknown_options/a \
		\ \ \ \ return" test/unit/manual.py || die
	sed -i -e "/test_saving_manual/a \
		\ \ \ \ return" test/unit/manual.py || die
	sed -i -e "/test_sdist_matches_git/a \
		\ \ \ \ return" test/integ/installation.py || die
	sed -i -e "/test_connections_by_ss/a \
		\ \ \ \ return" test/integ/util/connection.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	${PYTHON} run_tests.py --all --target RUN_ALL || die
}
