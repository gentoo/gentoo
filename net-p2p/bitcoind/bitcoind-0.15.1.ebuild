# Copyright 2010-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use systemd user

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
BITCOINCORE_COMMITHASH="7b57bc998f334775b50ebc8ca5e78ca728db4c58"
KNOTS_PV="${PV}.knots20171111"
KNOTS_P="${MyPN}-${KNOTS_PV}"

IUSE="+asm +bitcoin_policy_rbf examples knots libressl test upnp +wallet zeromq"

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc x86 ~amd64-linux ~x86-linux"

SRC_URI="
	https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"
CORE_DESC="https://bitcoincore.org/en/2017/11/11/release-${PV}/"
KNOTS_DESC="https://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.desc.html"

RDEPEND="
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/libevent
	>=dev-libs/libsecp256k1-0.0.0_pre20151118[recovery]
	dev-libs/univalue
	>=dev-libs/boost-1.52.0:=[threads(+)]
	upnp? ( >=net-libs/miniupnpc-1.9.20150916 )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx] )
	zeromq? ( net-libs/zeromq )
	virtual/bitcoin-leveldb
"
DEPEND="${RDEPEND}"

DOCS=( doc/bips.md doc/files.md doc/reduce-traffic.md doc/release-notes.md )

S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		einfo "You are building ${PN} from Bitcoin Knots."
		einfo "For more information, see ${KNOTS_DESC}"
	else
		einfo "You are building ${PN} from Bitcoin Core."
		einfo "For more information, see ${CORE_DESC}"
	fi
	if use bitcoin_policy_rbf; then
		einfo "Replace By Fee policy is enabled: Your node will preferentially mine and relay transactions paying the highest fee, regardless of receive order."
	else
		einfo "Replace By Fee policy is disabled: Your node will only accept the first transaction seen consuming a conflicting input, regardless of fee offered by later ones."
	fi
}

pkg_setup() {
	enewgroup bitcoin
	enewuser bitcoin -1 -1 /var/lib/bitcoin bitcoin
}

KNOTS_PATCH() { echo "${WORKDIR}/${KNOTS_P}.patches/${KNOTS_P}.$@.patch"; }

src_prepare() {
	sed -i 's/runscript/openrc-run/' contrib/init/${PN}.openrc || die

	sed -i 's/^\(complete -F _bitcoind bitcoind\) bitcoin-qt$/\1/' contrib/${PN}.bash-completion || die

	eapply "$(KNOTS_PATCH syslibs)"
	eapply "${FILESDIR}/${PN}-0.15.1-test-util-fix.patch"

	if use knots; then
		eapply "$(KNOTS_PATCH f)"
		eapply "$(KNOTS_PATCH branding)"
		eapply "$(KNOTS_PATCH ts)"
		eapply "${FILESDIR}/${PN}-0.15.1-test-build-fix.patch"
	fi

	eapply_user

	if ! use bitcoin_policy_rbf; then
		sed -i 's/\(DEFAULT_ENABLE_REPLACEMENT = \)true/\1false/' src/validation.h || die
	fi

	echo '#!/bin/true' >share/genbuild.sh || die
	mkdir -p src/obj || die
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h || die

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		$(use_enable asm experimental-asm)
		--without-qtdbus
		--with-libevent
		--without-qrencode
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-daemon
		--disable-util-cli
		--disable-util-tx
		--disable-bench
		--without-libs
		--without-gui
		--disable-ccache
		--disable-static
		--with-system-leveldb
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	rm -f "${ED%/}/usr/bin/test_bitcoin" || die

	insinto /etc/bitcoin
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
	fperms 600 /etc/bitcoin/bitcoin.conf

	newconfd "contrib/init/bitcoind.openrcconf" ${PN}
	newinitd "contrib/init/bitcoind.openrc" ${PN}
	systemd_newunit "${FILESDIR}/bitcoind.service-r1" "bitcoind.service"

	keepdir /var/lib/bitcoin/.bitcoin
	fperms 700 /var/lib/bitcoin
	fowners bitcoin:bitcoin /var/lib/bitcoin/
	fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
	dosym ../../../../etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf

	dodoc doc/REST-interface.md doc/tor.md
	doman "${FILESDIR}/bitcoin.conf.5"

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/${PN}.bash-completion ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{linearize,qos,tidy_datadir.sh}
		use zeromq && dodoc -r contrib/zmq
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/bitcoind.logrotate-r1" bitcoind
}

pkg_postinst() {
	einfo "To have ${PN} automatically use Tor when it's running, be sure your 'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup correctly, and:"
	einfo "- if using the init script: add the 'bitcoin' user to the 'tor' user group"
	einfo" - if running bitcoind directly: add that user to the 'tor' user group"
}
