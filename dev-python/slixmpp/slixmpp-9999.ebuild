# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Python 3 library for XMPP"
HOMEPAGE="
	https://codeberg.org/poezio/slixmpp/
	https://pypi.org/project/slixmpp/
"
LICENSE="MIT"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://codeberg.org/poezio/slixmpp.git"
	inherit git-r3
else
	inherit pypi
	KEYWORDS="amd64 ~riscv"
fi

DEPEND="
	net-dns/libidn:=
"
RDEPEND="
	dev-python/aiodns[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/pyasn1-modules[${PYTHON_USEDEP}]
	dev-python/pyasn1[${PYTHON_USEDEP}]
	${DEPEND}
	$(python_gen_cond_dep '
		>=dev-lang/python-3.12.1_p1:3.12
	' python3_12)
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	rm -rf slixmpp || die
	eunittest -s tests
}
