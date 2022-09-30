# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

BITCOINCORE_COMMITHASH="194b9b8792d9b0798fdb570b79fa51f1d1f5ebaf"
KNOTS_PV="${PV}.knots20210629"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="Bitcoin Core consensus library"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/$(ver_cut 1-2).x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm knots"

DEPEND="
	>dev-libs/libsecp256k1-0.1_pre20200911:=[recovery,schnorr]
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.13
"

DOCS=( doc/bips.md doc/release-notes.md doc/shared-libraries.md )

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/0.21.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2021/05/01/release-${PV}/"
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
}

src_prepare() {
	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${knots_patchdir}/${KNOTS_P}.syslibs.patch"

	if use knots; then
		eapply "${knots_patchdir}/${KNOTS_P}.f.patch"
		eapply "${knots_patchdir}/${KNOTS_P}.branding.patch"
		eapply "${knots_patchdir}/${KNOTS_P}.ts.patch"
	fi

	eapply_user

	echo '#!/bin/true' >share/genbuild.sh || die
	mkdir -p src/obj || die
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h || die

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		--without-qtdbus
		--without-qrencode
		--without-miniupnpc
		--disable-tests
		--disable-wallet
		--disable-zmq
		--with-libs
		--disable-util-cli
		--disable-util-tx
		--disable-util-wallet
		--disable-bench
		--without-daemon
		--without-gui
		--disable-fuzz
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
