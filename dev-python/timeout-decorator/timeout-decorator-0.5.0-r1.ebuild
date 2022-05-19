# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

EGIT_COMMIT=9fbc3ef5b6f8f8cba2eb7ba795813d6ec543e265
MY_P=${PN}-${EGIT_COMMIT}

DESCRIPTION="Timeout decorator"
HOMEPAGE="
	https://github.com/pnpnpn/timeout-decorator/
	https://pypi.org/project/timeout-decorator/
"
SRC_URI="
	https://github.com/pnpnpn/timeout-decorator/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest
