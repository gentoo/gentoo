# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitcoin-cli/bitcoin-cli-0.9.3.ebuild,v 1.4 2015/03/14 19:27:46 blueness Exp $

EAPI=4

inherit autotools eutils

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
LJR_PV="${PV}.ljr20141002"
LJR_PATCH="bitcoin-${LJR_PV}.patch"

DESCRIPTION="Command-line JSON-RPC client specifically designed for talking to Bitcoin Core Daemon"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="https://github.com/${MyPN}/${MyPN}/archive/v${MyPV}.tar.gz -> ${MyPN}-v${PV}.tgz
	http://luke.dashjr.org/programs/bitcoin/files/bitcoind/luke-jr/0.9.x/${LJR_PV}/${LJR_PATCH}.xz
"

LICENSE="MIT ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.52.0[threads(+)]
	dev-libs/openssl:0[-bindist]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MyP}"

src_prepare() {
	epatch "${WORKDIR}/${LJR_PATCH}"
	rm -r src/leveldb
	eautoreconf
}

src_configure() {
	econf \
		--disable-ccache \
		--without-miniupnpc  \
		--disable-tests  \
		--disable-wallet  \
		--without-daemon  \
		--without-gui
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/README.md doc/release-notes.md
	dodoc doc/assets-attribution.md doc/tor.md
}
