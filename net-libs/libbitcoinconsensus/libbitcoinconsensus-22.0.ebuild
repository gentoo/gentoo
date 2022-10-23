# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

BITCOINCORE_COMMITHASH="a0988140b71485ad12c3c3a4a9573f7c21b1eff8"
KNOTS_PV="${PV}.knots20211108"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="Bitcoin Core consensus library"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/$(ver_cut 1).x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm knots"

RDEPEND="
	>dev-libs/libsecp256k1-0.1_pre20200911:=[recovery,schnorr]
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
"

DOCS=( doc/bips.md doc/release-notes.md doc/shared-libraries.md )

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/22.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2021/09/13/release-${PV}/"
	fi
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
	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${knots_patchdir}/${KNOTS_P}_p1-syslibs.patch"

	if use knots; then
		eapply "${knots_patchdir}/${KNOTS_P}_p2-fixes.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p3-features.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p4-branding.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p5-ts.patch"
	fi

	default

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
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
		--disable-static
		--with-system-libsecp256k1
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
