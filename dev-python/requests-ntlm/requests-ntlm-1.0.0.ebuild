# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="HTTP NTLM authentication using the requests library"
HOMEPAGE="https://github.com/requests/requests-ntlm"
SRC_URI="https://github.com/requests/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/ntlm-auth-1.0.2[${PYTHON_USEDEP}]"
