# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use systemd

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="
	https://bitcoincore.org/bin/bitcoin-core-${PV}/${P/d}.tar.gz
"
S="${WORKDIR}"/${P/d}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm +berkdb examples +external-signer nat-pmp sqlite systemtap test upnp +wallet zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	sqlite? ( wallet )
	berkdb? ( wallet )
	wallet? ( || ( berkdb sqlite ) )
"
# dev-libs/univalue is now bundled as upstream dropped support for system copy
# and their version in the Bitcoin repo has deviated a fair bit from upstream.
# Upstream also seems very inactive.
RDEPEND="
	acct-group/bitcoin
	acct-user/bitcoin
	dev-libs/boost:=
	dev-libs/libevent:=
	>=dev-libs/libsecp256k1-0.2.0:=[recovery,schnorr]
	>=dev-libs/univalue-1.0.4:=
	virtual/bitcoin-leveldb
	nat-pmp? ( net-libs/libnatpmp )
	sqlite? ( >=dev-db/sqlite-3.7.17:= )
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	berkdb? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
DEPEND="
	${RDEPEND}
	systemtap? ( dev-util/systemtap )
"

DOCS=(
	doc/bips.md
	doc/bitcoin-conf.md
	doc/descriptors.md
	doc/files.md
	doc/JSON-RPC-interface.md
	doc/psbt.md
	doc/reduce-memory.md
	doc/reduce-traffic.md
	doc/release-notes.md
	doc/REST-interface.md
	doc/tor.md
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
	sed -i 's/^\(complete -F _bitcoind bitcoind\) bitcoin-qt$/\1/' contrib/${PN}.bash-completion || die

	default

	eautoreconf

	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable asm)
		--without-qtdbus
		$(use_enable systemtap ebpf)
		$(use_enable external-signer)
		$(use_with nat-pmp natpmp)
		$(use_with nat-pmp natpmp-default)
		--without-qrencode
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-daemon
		--disable-util-cli
		--disable-util-tx
		--disable-util-util
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-gui
		--disable-fuzz
		--disable-fuzz-binary
		--disable-ccache
		--disable-static
		$(use_with berkdb bdb)
		$(use_with sqlite)
		--with-system-leveldb
		--with-system-libsecp256k1
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use test; then
		rm -f "${ED}/usr/bin/test_bitcoin" || die
	fi

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
		dodoc -r contrib/{linearize,qos}
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
