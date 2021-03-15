# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

DESCRIPTION="#1 quality TLS certs while you wait, for the discerning tester"
HOMEPAGE="https://github.com/python-trio/trustme"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/service_identity[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
