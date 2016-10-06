# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Official golang implementation of the Ethereum protocol"
HOMEPAGE="https://github.com/ethereum/go-ethereum"
SRC_URI="https://github.com/ethereum/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="evm"

DEPEND="dev-lang/go:="
RDEPEND="${DEPEND}"

src_compile() {
	emake geth
	use evm && emake evm
}

src_install() {
	einstalldocs

	dobin build/bin/geth
	use evm && dobin build/bin/evm
}
