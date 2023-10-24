# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Transitional package for net-p2p/bitcoin-core[libs]"
HOMEPAGE="https://bitcoincore.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+asm"

RDEPEND="~net-p2p/bitcoin-core-${PV}[libs,asm=]"
