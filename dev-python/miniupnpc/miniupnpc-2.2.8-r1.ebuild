# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 verify-sig

MY_P=${P/python-}
DESCRIPTION="Python bindings for UPnP client library"
HOMEPAGE="
	http://miniupnp.free.fr/
	https://miniupnp.tuxfamily.org/
	https://github.com/miniupnp/miniupnp/
"
SRC_URI="
	https://miniupnp.tuxfamily.org/files/${MY_P}.tar.gz
	verify-sig? (
		https://miniupnp.tuxfamily.org/files/${MY_P}.tar.gz.sig
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"

DEPEND="
	>=net-libs/miniupnpc-${PV}:0=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-miniupnp )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/miniupnp.asc

PATCHES=(
	"${FILESDIR}"/miniupnpc-2.2.3-shared-lib.patch
)

# DOCS are installed by net-libs/miniupnpc.
DOCS=()

# Example test command:
# python -c 'import miniupnpc; u = miniupnpc.UPnP(); u.discover(); u.selectigd(); print(u.externalipaddress())'
distutils_enable_tests import-check
