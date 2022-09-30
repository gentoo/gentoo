# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use desktop flag-o-matic xdg-utils

BITCOINCORE_COMMITHASH="a0988140b71485ad12c3c3a4a9573f7c21b1eff8"
KNOTS_PV="${PV}.knots20211108"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="An end-user Qt GUI for the Bitcoin crypto-currency"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/$(ver_cut 1).x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE="+asm +berkdb dbus +external-signer kde knots nat-pmp +qrcode sqlite systemtap test upnp +wallet zeromq"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	sqlite? ( wallet )
	berkdb? ( wallet )
	wallet? ( || ( berkdb sqlite ) )
"
RDEPEND="
	dev-libs/boost:=
	>dev-libs/libsecp256k1-0.1_pre20200911:=[recovery,schnorr]
	>=dev-libs/univalue-1.0.4:=
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
DEPEND="${RDEPEND}
	systemtap? ( dev-util/systemtap )
"
BDEPEND="
	>=sys-devel/automake-1.13
	|| ( >=sys-devel/gcc-7[cxx] >=sys-devel/clang-5 )
	dev-qt/linguist-tools:5
	knots? (
		gnome-base/librsvg
		media-gfx/imagemagick[png]
	)
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
	elog
	elog "Replace By Fee policy is now always enabled by default: Your node will"
	elog "preferentially mine and relay transactions paying the highest fee, regardless"
	if use knots; then
		elog "of receive order. To disable RBF, set mempoolreplacement=never in bitcoin.conf"
	else  # Bitcoin Core doesn't support disabling RBF anymore
		elog "of receive order. To disable RBF, rebuild with USE=knots to get ${PN}"
		elog "from Bitcoin Knots, and set mempoolreplacement=never in bitcoin.conf"
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
	sed -i 's/^\(complete -F _bitcoind \)bitcoind \(bitcoin-qt\)$/\1\2/' contrib/bitcoind.bash-completion || die

	# Save the generic icon for later
	cp src/qt/res/src/bitcoin.svg bitcoin128.svg || die

	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${knots_patchdir}/${KNOTS_P}_p1-syslibs.patch"

	if use knots; then
		eapply "${knots_patchdir}/${KNOTS_P}_p2-fixes.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p3-features.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p4-branding.patch"
		eapply "${knots_patchdir}/${KNOTS_P}_p5-ts.patch"
	fi

	eapply_user

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
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
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	if use test; then
		rm -f "${ED}/usr/bin/test_bitcoin" || die
	fi

	insinto /usr/share/icons/hicolor/scalable/apps/
	doins bitcoin128.svg
	if use knots; then
		newins src/qt/res/src/bitcoin.svg bitcoinknots.svg
	fi

	cp "${FILESDIR}/org.bitcoin.bitcoin-qt.desktop" "${T}" || die
	if ! use knots; then
		sed -i 's/Knots/Core/;s/^\(Icon=\).*$/\1bitcoin128/' "${T}/org.bitcoin.bitcoin-qt.desktop" || die
	fi
	domenu "${T}/org.bitcoin.bitcoin-qt.desktop"

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}

	if use kde; then
		insinto /usr/share/kservices5
		doins "${FILESDIR}/bitcoin-qt.protocol"
		dosym "../../kservices5/bitcoin-qt.protocol" "/usr/share/kde4/services/bitcoin-qt.protocol"
	fi
}

update_caches() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	update_caches

	elog "To have ${PN} automatically use Tor when it's running, be sure your"
	elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup"
	elog "correctly, and add your user to the 'tor' user group."
}

pkg_postrm() {
	update_caches
}
