# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )
inherit distutils-r1

DESCRIPTION="Intelligent recursive search/replace utility"
HOMEPAGE="https://rpl.sourceforge.net/ https://github.com/rrthomas/rpl"
SRC_URI="
	https://github.com/rrthomas/rpl/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]"
BDEPEND="
	${RDEPEND}
	dev-python/argparse-manpage[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/chainstream[${PYTHON_USEDEP}]
	test? ( dev-python/pytest-datafiles[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

src_prepare() {
	sed -i "s/VERSION = importlib.metadata.version('rpl')/VERSION = '${PV}'/" rpl/__init__.py || die
	distutils-r1_src_prepare
}
