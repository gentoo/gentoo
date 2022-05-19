# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 verify-sig

DESCRIPTION="Python bindings for LXC"
HOMEPAGE="https://linuxcontainers.org/lxc/"
SRC_URI="https://linuxcontainers.org/downloads/lxc/${P}.tar.gz
	verify-sig? ( https://linuxcontainers.org/downloads/lxc/${P}.tar.gz.asc )"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
IUSE="verify-sig"

RDEPEND="app-containers/lxc"
BDEPEND="virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-linuxcontainers )"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/linuxcontainers.asc
