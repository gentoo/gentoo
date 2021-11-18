# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

EGIT_COMMIT=9fbc3ef5b6f8f8cba2eb7ba795813d6ec543e265
MY_P=${PN}-${EGIT_COMMIT}

DESCRIPTION="Timeout decorator"
HOMEPAGE="
	https://pypi.org/project/timeout-decorator/
	https://github.com/pnpnpn/timeout-decorator/"
SRC_URI="
	https://github.com/pnpnpn/timeout-decorator/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ~ppc64 sparc x86"

distutils_enable_tests pytest
