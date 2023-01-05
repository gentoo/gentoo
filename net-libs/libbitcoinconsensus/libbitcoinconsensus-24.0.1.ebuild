# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Bitcoin Core consensus library"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="
	https://bitcoincore.org/bin/bitcoin-core-${PV}/bitcoin-${PV}.tar.gz
"
S="${WORKDIR}"/bitcoin-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm knots"
# Tries to run test/test_bitcoin which isn't built as part of this package
RESTRICT="test"

RDEPEND=">=dev-libs/libsecp256k1-0.2.0:=[recovery,schnorr]"
DEPEND="${RDEPEND}"

DOCS=( doc/bips.md doc/release-notes.md doc/shared-libraries.md )

PATCHES=(
	"${FILESDIR}"/24.0.1-syslibs.patch
)

pkg_pretend() {
	elog "You are building ${PN} from Bitcoin Core."
	elog "For more information, see:"
	elog "https://bitcoincore.org/en/releases/${PV}/"

	if has_version "<${CATEGORY}/${PN}-0.21.1" ; then
		ewarn "CAUTION: BITCOIN PROTOCOL CHANGE INCLUDED"
		ewarn "This release adds enforcement of the Taproot protocol change to the Bitcoin"
		ewarn "rules, beginning in November. Protocol changes require user consent to be"
		ewarn "effective, and if enforced inconsistently within the community may compromise"
		ewarn "your security or others! If you do not know what you are doing, learn more"
		ewarn "before November. (You must make a decision either way - simply not upgrading"
		ewarn "is insecure in all scenarios.)"
		ewarn "To learn more, see https://bitcointaproot.cc"
	fi

	if [[ ${MERGE_TYPE} != "binary" ]] ; then
		if ! test-flag-CXX -std=c++17 ; then
			die "Building ${CATEGORY}/${P} requires at least GCC 7 or Clang 5"
		fi
	fi
}

src_prepare() {
	default

	eautoreconf

	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable asm)
		--without-qtdbus
		--disable-ebpf
		--without-natpmp
		--without-qrencode
		--without-miniupnpc
		--disable-tests
		--disable-wallet
		--disable-zmq
		--with-libs
		--disable-util-cli
		--disable-util-tx
		--disable-util-util
		--disable-util-wallet
		--disable-bench
		--without-daemon
		--without-gui
		--disable-fuzz
		--disable-fuzz-binary
		--disable-ccache
		--with-system-libsecp256k1
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
