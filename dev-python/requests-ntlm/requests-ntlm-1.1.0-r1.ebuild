# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="${PN/-/_}"

DESCRIPTION="HTTP NTLM authentication using the requests library"
HOMEPAGE="https://github.com/requests/requests-ntlm"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/ntlm-auth-1.0.2[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_PN}-${PV}
