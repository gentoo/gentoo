# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6..9}} pypy3 )
inherit distutils-r1

DESCRIPTION="#1 quality TLS certs while you wait, for the discerning tester"
HOMEPAGE="https://github.com/python-trio/trustme"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]' -2 )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/futures[${PYTHON_USEDEP}]' -2 )
	)"

distutils_enable_tests pytest
