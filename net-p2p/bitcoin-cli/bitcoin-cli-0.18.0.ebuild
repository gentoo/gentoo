# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

BITCOINCORE_COMMITHASH="2472733a24a9364e4c6233ccd04166a26a68cc65"
KNOTS_PV="${PV}.knots20190502"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="Command-line JSON-RPC client specifically for interfacing with bitcoind"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.18.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="knots libressl"

DEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	dev-libs/libevent:=
	>=dev-libs/univalue-1.0.4:=
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
"
RDEPEND="${DEPEND}"

DOCS=( doc/release-notes.md )

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/0.18.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2019/05/02/release-${PV}/"
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
		--disable-asm
		--without-qtdbus
		--without-qrencode
		--without-miniupnpc
		--disable-tests
		--disable-wallet
		--disable-zmq
		--enable-util-cli
		--disable-util-tx
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
		--without-gui
		--without-rapidcheck
		--disable-fuzz
		--disable-ccache
		--disable-static
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	newbashcomp contrib/bitcoin-cli.bash-completion ${PN}
}
