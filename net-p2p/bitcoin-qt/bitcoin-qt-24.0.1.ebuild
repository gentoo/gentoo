# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use desktop xdg

DESCRIPTION="An end-user Qt GUI for the Bitcoin crypto-currency"
HOMEPAGE="https://bitcoincore.org/"
SRC_URI="
	https://bitcoincore.org/bin/bitcoin-core-${PV}/${P/-qt}.tar.gz
"
S="${WORKDIR}"/${P/-qt}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+asm +berkdb dbus +external-signer kde nat-pmp +qrcode sqlite systemtap test upnp +wallet zeromq"
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
	dev-libs/boost:=
	>=dev-libs/libsecp256k1-0.2.0:=[recovery,schnorr]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	virtual/bitcoin-leveldb
	dbus? ( dev-qt/qtdbus:5 )
	dev-libs/libevent:=
	nat-pmp? ( net-libs/libnatpmp )
	qrcode? (
		media-gfx/qrencode:=
	)
	sqlite? ( >=dev-db/sqlite-3.7.17:= )
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	berkdb? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
DEPEND="
	${RDEPEND}
	systemtap? ( dev-util/systemtap )
"
BDEPEND="dev-qt/linguist-tools:5"

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
	sed -i 's/^\(complete -F _bitcoind \)bitcoind \(bitcoin-qt\)$/\1\2/' contrib/bitcoind.bash-completion || die

	# Save the generic icon for later
	cp src/qt/res/src/bitcoin.svg bitcoin128.svg || die

	default

	eautoreconf

	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable asm)
		$(use_with dbus qtdbus)
		$(use_enable systemtap ebpf)
		$(use_enable external-signer)
		$(use_with nat-pmp natpmp)
		$(use_with nat-pmp natpmp-default)
		$(use_with qrcode qrencode)
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-gui=qt5
		--disable-util-cli
		--disable-util-tx
		--disable-util-util
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
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
		rm -f "${ED}/usr/bin/test_bitcoin-qt" || die
	fi

	insinto /usr/share/icons/hicolor/scalable/apps/
	doins bitcoin128.svg

	cp "${FILESDIR}/org.bitcoin.bitcoin-qt.desktop" "${T}" || die
	sed -i 's/Knots/Core/;s/^\(Icon=\).*$/\1bitcoin128/' "${T}/org.bitcoin.bitcoin-qt.desktop" || die
	domenu "${T}/org.bitcoin.bitcoin-qt.desktop"

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}

	if use kde; then
		insinto /usr/share/kservices5
		doins "${FILESDIR}/bitcoin-qt.protocol"
		dosym "../../kservices5/bitcoin-qt.protocol" "/usr/share/kde4/services/bitcoin-qt.protocol"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "To have ${PN} automatically use Tor when it's running, be sure your"
	elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup"
	elog "correctly, and add your user to the 'tor' user group."
}
