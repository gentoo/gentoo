# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/litecoin-qt/litecoin-qt-0.10.2.2.ebuild,v 1.2 2015/07/12 00:45:07 patrick Exp $

EAPI=5

DB_VER="4.8"

LANGS="ach af_ZA ar be_BY bg bs ca_ES ca ca@valencia cmn cs cy da de el_GR en eo es_CL es_DO es_MX es es_UY et eu_ES fa_IR fa fi fr_CA fr gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mn ms_MY nb nl pam pl pt_BR pt_PT ro_RO ru sah sk sl_SI sq sr sv th_TH tr uk ur_PK uz@Cyrl vi vi_VN zh_CN zh_HK zh_TW"

inherit autotools db-use eutils fdo-mime gnome2-utils kde4-functions qt4-r2

MyPV="${PV/_/-}"
MyPN="litecoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="P2P Internet currency based on Bitcoin but easier to mine"
HOMEPAGE="https://litecoin.org/"
SRC_URI="https://github.com/${MyPN}-project/${MyPN}/archive/v${MyPV}.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT ISC GPL-3 LGPL-2.1 public-domain || ( CC-BY-SA-3.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus kde +qrcode qt5 upnp"

RDEPEND="
	dev-libs/boost[threads(+)]
	dev-libs/openssl:0[-bindist]
	qrcode? (
		media-gfx/qrencode
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	virtual/bitcoin-leveldb
	!qt5? (
		dev-qt/qtgui:4
		dbus? (
			dev-qt/qtdbus:4
		)
	)
	qt5? (
		dev-qt/qtgui:5
		dbus? (
			dev-qt/qtdbus:5
		)
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

DOCS="doc/README.md doc/release-notes.md"

S="${WORKDIR}/${MyP}"

src_prepare() {
	epatch "${FILESDIR}/0.9.0-sys_leveldb.patch"
	eautoreconf
	rm -r src/leveldb

	cd src || die

	local filt= yeslang= nolang=

	for lan in $LANGS; do
		if [ ! -e qt/locale/bitcoin_$lan.ts ]; then
			ewarn "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in $(ls qt/locale/*.ts)
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "linguas_$x"; then
			nolang="$nolang $x"
			#rm "$ts"
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done

	filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
	sed "/${filt}/d" -i 'qt/bitcoin_locale.qrc'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"
}

src_configure() {
	local my_econf=
	if use upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	econf \
		--enable-wallet \
		--disable-ccache \
		--disable-static \
		--disable-tests \
		--with-system-leveldb \
		--with-system-libsecp256k1  \
		--without-libs \
		--without-utils \
		--without-daemon  \
        --with-gui=$(usex qt5 qt5 qt4) \
        $(use_with dbus qtdbus)  \
        $(use_with qrcode qrencode)  \
		${my_econf}
}

src_install() {
	default

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"

	make_desktop_entry "${PN} %u" "Litecoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/litecoin;\nTerminal=false"

	newman contrib/debian/manpages/bitcoin-qt.1 ${PN}.1

	if use kde; then
		insinto /usr/share/kde4/services
		newins contrib/debian/bitcoin-qt.protocol ${PN}.protocol
	fi
}

update_caches() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	buildsycoca
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
