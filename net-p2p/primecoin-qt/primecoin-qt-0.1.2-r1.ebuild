# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/primecoin-qt/primecoin-qt-0.1.2-r1.ebuild,v 1.2 2014/08/10 20:38:12 slyfox Exp $

EAPI=5

DB_VER="4.8"

LANGS="af_ZA ar bg bs ca_ES ca cs cy da de el_GR en eo es_CL es et eu_ES fa_IR fa fi fr_CA fr gu_IN he hi_IN hr hu it ja la lt lv_LV nb nl pl pt_BR pt_PT ro_RO ru sk sr sv th_TH tr uk zh_CN zh_TW"

inherit db-use eutils fdo-mime gnome2-utils kde4-functions qt4-r2

MyPV="${PV/_/-}"
MyPN="primecoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="Cryptocurrency forked from Bitcoin which aims to be energy efficiency"
HOMEPAGE="http://primecoin.org/"
SRC_URI="mirror://sourceforge/${MyPN}/${MyP}-linux.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT ISC GPL-3 LGPL-2.1 public-domain || ( CC-BY-SA-3.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus ipv6 kde +qrcode upnp"

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
	<=dev-libs/leveldb-1.12.0[-snappy]
	dev-qt/qtgui:4
	dbus? (
		dev-qt/qtdbus:4
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

DOCS="doc/README.md doc/release-notes.md"

S="${WORKDIR}/${MyP}-linux/src"

src_prepare() {
	epatch "${FILESDIR}"/${MyPN}-sys_leveldb.patch
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
			rm "$ts"
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done

	filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
	sed "/${filt}/d" -i 'qt/bitcoin.qrc'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"
}

src_configure() {
	OPTS=()

	use dbus && OPTS+=("USE_DBUS=1")
	if use upnp; then
		OPTS+=("USE_UPNP=1")
	else
		OPTS+=("USE_UPNP=-")
	fi

	use qrcode && OPTS+=("USE_QRCODE=1")
	use ipv6 || OPTS+=("USE_IPV6=-")

	OPTS+=("USE_SYSTEM_LEVELDB=1")
	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	if has_version '>=dev-libs/boost-1.52'; then
		OPTS+=("LIBS+=-lboost_chrono\$\$BOOST_LIB_SUFFIX")
	fi

	#The primecoin codebase is mostly taken from bitcoin-qt
	eqmake4 bitcoin-qt.pro "${OPTS[@]}"
}

#Tests are broken
#src_test() {
#	cd src || die
#	emake -f makefile.unix "${OPTS[@]}" test_primecoin
#	./test_primecoin || die 'Tests failed'
#}

src_install() {
	qt4-r2_src_install

	dobin ${PN}

	insinto /usr/share/pixmaps
	newins "share/pixmaps/primecoin.ico" "${PN}.ico"

	make_desktop_entry "${PN} %u" "Primecoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/primecoin;\nTerminal=false"

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
