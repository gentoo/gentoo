# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1

DESCRIPTION="Command-line Bitcoin transaction tool"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="
	https://bitcoincore.org/bin/bitcoin-core-${PV}/${P/-tx}.tar.gz
"
S="${WORKDIR}"/${P/-tx}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

# TODO: Can we drop virtual/bitcoin-leveldb from some bitcoin-*?
# (only bitcoin-qt, bitcoind should need it?)
RDEPEND="
	>=dev-libs/boost-1.64.0:=
	>=dev-libs/libsecp256k1-0.2:=[recovery,schnorr]
	virtual/bitcoin-leveldb
"
DEPEND="${RDEPEND}"

DOCS=(
	doc/bips.md
	doc/release-notes.md
)

PATCHES=(
	"${FILESDIR}"/24.0.1-syslibs.patch
)

pkg_pretend() {
	elog "You are building ${PN} from Bitcoin Core."
	elog "For more information, see:"
	elog "https://bitcoincore.org/en/releases/${PV}/"
}

src_prepare() {
	default

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local myeconfargs=(
		--disable-asm
		--without-qtdbus
		--disable-ebpf
		--without-natpmp
		--without-qrencode
		--without-miniupnpc
		--disable-tests
		--disable-wallet
		--disable-zmq
		--enable-util-tx
		--disable-util-util
		--disable-util-cli
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
		--without-gui
		--disable-fuzz
		--disable-fuzz-binary
		--disable-ccache
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newbashcomp contrib/${PN}.bash-completion ${PN}
}
