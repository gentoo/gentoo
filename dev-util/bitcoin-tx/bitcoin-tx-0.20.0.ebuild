# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

BITCOINCORE_COMMITHASH="a62f0ed64f8bbbdfe6467ac5ce92ef5b5222d1bd"
KNOTS_PV="${PV}.knots20200614"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="Command-line Bitcoin transaction tool"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.20.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="knots libressl"

DEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	>dev-libs/libsecp256k1-0.1_pre20170321:=[recovery]
	>=dev-libs/univalue-1.0.4:=
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-devel/autoconf-2.69
	>=sys-devel/automake-1.13
"

DOCS=(
	doc/bips.md
	doc/release-notes.md
)

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/0.20.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2020/06/03/release-${PV}/"
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

	eapply "${FILESDIR}/${PV}-no-libevent.patch"

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
		--enable-util-tx
		--disable-util-cli
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
		--without-gui
		--disable-fuzz
		--disable-ccache
		--disable-static
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	newbashcomp contrib/${PN}.bash-completion ${PN}
}
