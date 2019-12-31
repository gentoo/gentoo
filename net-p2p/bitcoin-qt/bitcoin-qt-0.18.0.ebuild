# Copyright 2010-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use gnome2-utils xdg-utils

BITCOINCORE_COMMITHASH="2472733a24a9364e4c6233ccd04166a26a68cc65"
KNOTS_PV="${PV}.knots20190502"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="An end-user Qt GUI for the Bitcoin crypto-currency"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.18.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE="+asm +bip70 +bitcoin_policy_rbf dbus kde knots libressl +qrcode +system-leveldb test upnp +wallet zeromq"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	>=dev-libs/libsecp256k1-0.0.0_pre20151118:=[recovery]
	>=dev-libs/univalue-1.0.4:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	system-leveldb? ( virtual/bitcoin-leveldb )
	bip70? ( dev-libs/protobuf:= )
	dbus? ( dev-qt/qtdbus:5 )
	dev-libs/libevent:=
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	qrcode? (
		media-gfx/qrencode:=
	)
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	knots? (
		gnome-base/librsvg
		media-gfx/imagemagick[png]
	)
"

DOCS=( doc/bips.md doc/bitcoin-conf.md doc/descriptors.md doc/files.md doc/JSON-RPC-interface.md doc/psbt.md doc/reduce-traffic.md doc/release-notes.md doc/REST-interface.md doc/tor.md )

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
	if use bitcoin_policy_rbf; then
		elog "Replace By Fee policy is enabled: Your node will preferentially mine and"
		elog "relay transactions paying the highest fee, regardless of receive order."
	else
		elog "Replace By Fee policy is disabled: Your node will only accept the first"
		elog "transaction seen consuming a conflicting input, regardless of fee"
		elog "offered by later ones."
	fi
}

src_prepare() {
	sed -i 's/^\(complete -F _bitcoind \)bitcoind \(bitcoin-qt\)$/\1\2/' contrib/bitcoind.bash-completion || die

	# Save the generic icon for later
	cp src/qt/res/src/bitcoin.svg bitcoin128.svg || die

	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${FILESDIR}"/${PN}-0.16.3-boost-1.72-missing-include.patch
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
	rm -r src/secp256k1 || die
	if use system-leveldb; then
		rm -r src/leveldb || die
	fi
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		$(use_enable bip70)
		$(use_with dbus qtdbus)
		$(use_with qrcode qrencode)
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-gui=qt5
		--disable-util-cli
		--disable-util-tx
		--disable-util-wallet
		--disable-bench
		--without-libs
		--without-daemon
		--without-rapidcheck
		--disable-fuzz
		--disable-ccache
		--disable-static
		$(use_with system-leveldb)
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	rm -f "${ED%/}/usr/bin/test_bitcoin" || die

	insinto /usr/share/icons/hicolor/scalable/apps/
	doins bitcoin128.svg
	if use knots; then
		newins src/qt/res/src/bitcoin.svg bitcoinknots.svg
	fi

	insinto /usr/share/applications
	doins "${FILESDIR}/org.bitcoin.bitcoin-qt.desktop"
	if ! use knots; then
		sed -i 's/Knots/Core/;s/^\(Icon=\).*$/\1bitcoin128/' "${D}/usr/share/applications/org.bitcoin.bitcoin-qt.desktop" || die
	fi

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}

	if use kde; then
		insinto /usr/share/kservices5
		doins "${FILESDIR}/bitcoin-qt.protocol"
		dosym "../../kservices5/bitcoin-qt.protocol" "/usr/share/kde4/services/bitcoin-qt.protocol"
	fi
}

update_caches() {
	gnome2_icon_cache_update
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
