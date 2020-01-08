# Copyright 2010-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use systemd user

BITCOINCORE_COMMITHASH="49e34e288005a5b144a642e197b628396f5a0765"
KNOTS_PV="${PV}.knots20180918"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.16.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="+asm +bitcoin_policy_rbf examples knots libressl test upnp +wallet zeromq"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	dev-libs/libevent:=
	>=dev-libs/libsecp256k1-0.0.0_pre20151118:=[recovery]
	dev-libs/univalue:=
	virtual/bitcoin-leveldb
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
RDEPEND="${DEPEND}"

DOCS=( doc/bips.md doc/files.md doc/reduce-traffic.md doc/release-notes.md doc/REST-interface.md doc/tor.md )

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/0.16.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2018/09/18/release-${PV}/"
	fi
	if use bitcoin_policy_rbf; then
		elog "Replace By Fee policy is enabled: Your node will preferentially mine and"
		elog "relay transactions paying the highest fee, regardless of receive order."
	else
		elog "Replace By Fee policy is disabled: Your node will only accept the first"
		elog "transaction seen consuming a conflicting input, regardless of fee"
		elog "offered by later ones."
	fi
}

pkg_setup() {
	enewgroup bitcoin
	enewuser bitcoin -1 -1 /var/lib/bitcoin bitcoin
}

src_prepare() {
	sed -i 's/^\(complete -F _bitcoind bitcoind\) bitcoin-qt$/\1/' contrib/${PN}.bash-completion || die

	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${FILESDIR}"/${PN}-0.16.3-missing-include.patch
	eapply "${knots_patchdir}/${KNOTS_P}.syslibs.patch"

	if use knots; then
		eapply "${knots_patchdir}/${KNOTS_P}.f.patch"
		eapply "${knots_patchdir}/${KNOTS_P}.branding.patch"
		eapply "${knots_patchdir}/${KNOTS_P}.ts.patch"
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
		$(use_enable asm)
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
	systemd_newunit "contrib/init/bitcoind.service" "bitcoind.service"

	keepdir /var/lib/bitcoin/.bitcoin
	fperms 700 /var/lib/bitcoin
	fowners bitcoin:bitcoin /var/lib/bitcoin/
	fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
	dosym ../../../../etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf

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
	elog "To have ${PN} automatically use Tor when it's running, be sure your"
	elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup"
	elog "correctly, and:"
	elog "- Using an init script: add the 'bitcoin' user to the 'tor' user group."
	elog "- Running bitcoind directly: add that user to the 'tor' user group."
}
