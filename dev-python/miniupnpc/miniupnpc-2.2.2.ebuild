# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1 verify-sig

DESCRIPTION="Python bindings for UPnP client library"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz
	verify-sig? ( http://miniupnp.free.fr/files/${P}.tar.gz.sig )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=net-libs/miniupnpc-${PV}:0="
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( app-crypt/openpgp-keys-miniupnp )"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/miniupnp.asc

PATCHES=(
	"${FILESDIR}"/miniupnpc-2.0.20171102-shared-lib.patch
)

# DOCS are installed by net-libs/miniupnpc.
DOCS=()

# Example test command:
# python -c 'import miniupnpc; u = miniupnpc.UPnP(); u.discover(); u.selectigd(); print(u.externalipaddress())'
