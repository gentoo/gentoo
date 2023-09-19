# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python interface for c-ares"
HOMEPAGE="
	https://github.com/saghul/pycares/
	https://pypi.org/project/pycares/
"
SRC_URI="
	https://github.com/saghul/pycares/archive/${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/pycares-${P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv ~x86"
IUSE="test"
# Tests fail with network-sandbox, since they try to resolve google.com
PROPERTIES="test_network"
RESTRICT="test"

DEPEND="
	net-dns/c-ares:=
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/cffi[${PYTHON_USEDEP}]
	' 'python*')
"
RDEPEND="
	dev-python/idna[${PYTHON_USEDEP}]
	${DEPEND}
	${BDEPEND}
"
BDEPEND+="
	test? (
		dev-python/idna[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# regression due to Internet changing (probably)
	# https://github.com/saghul/pycares/issues/187
	tests/test_all.py::DNSTest::test_query_class_chaos
)

export PYCARES_USE_SYSTEM_LIB=1
