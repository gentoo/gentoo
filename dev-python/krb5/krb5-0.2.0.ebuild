# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Kerberos API bindings for Python"
HOMEPAGE="https://pypi.org/project/krb5/ https://github.com/jborean93/pykrb5"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	virtual/krb5
"
BDEPEND="test? ( dev-python/k5test[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
