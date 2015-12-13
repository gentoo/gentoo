# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use autotools eutils toolchain-funcs user fdo-mime gnome2-utils kde4-functions qt4-r2

DESCRIPTION="BitcoinXT crypto-currency GUI wallet"
HOMEPAGE="https://github/bitcoinxt/bitcoinxt"
My_PV="${PV/\.0d/}D"
SRC_URI="https://github.com/bitcoinxt/bitcoinxt/archive/v${My_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus +doc kde libressl ljr +logrotate +qrcode qt4 qt5 +ssl test upnp +wallet"
REQUIRED_USE="${REQUIRED_USE} ^^ ( qt4 qt5 )"

LANGS="ach af_ZA ar be_BY bg bs ca ca@valencia ca_ES cmn cs cy da de el_GR en eo es es_CL es_DO es_MX es_UY et eu_ES fa fa_IR fi fr fr_CA gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mn ms_MY nb nl pam pl pt_BR pt_PT ro_RO ru sah sk sl_SI sq sr sv th_TH tr uk ur_PK uz@Cyrl vi vi_VN zh_HK zh_CN zh_TW"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

OPENSSL_DEPEND="
	!libressl? ( dev-libs/openssl:0[-bindist] )
	libressl? ( dev-libs/libressl )"
WALLET_DEPEND="media-gfx/qrencode sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"

RDEPEND="
	dev-libs/protobuf
	qrcode? (
		media-gfx/qrencode
	)
	qt4? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtgui:5 dev-qt/qtnetwork:5 dev-qt/qtwidgets:5 dev-qt/linguist-tools:5 )
	app-shells/bash:0
	dev-libs/boost[threads(+)]
	dev-libs/glib:2
	dev-libs/crypto++
	ssl? ( ${OPENSSL_DEPEND} )
	logrotate? ( app-admin/logrotate )
	wallet? ( ${WALLET_DEPEND} )
	upnp? ( net-libs/miniupnpc )
	virtual/bitcoin-leveldb
	dbus? (
		qt4? ( dev-qt/qtdbus:4 )
		qt5? ( dev-qt/qtdbus:5 )
	)
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/bitcoinxt-${My_PV}"

pkg_setup() {
	local UG='bitcoinxt'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoinxt "${UG}"
	# force this user to the sh shell - which is normally bash
	chsh -s /bin/sh ${UG}
	elog "user ${UG} set to allow logins"
	elog ""
	elog "Do not forget to set the password for ${UG} to allow you to log in"
}

src_prepare() {
	epatch "${FILESDIR}/9999-syslibs.patch"

	local filt= yeslang= nolang=

	for lan in $LANGS; do
		if [ ! -e src/qt/locale/bitcoin_$lan.ts ]; then
			die "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in $(ls src/qt/locale/*.ts)
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
	sed "/${filt}/d" -i 'src/qt/bitcoin_locale.qrc'
	sed "s/locale\/${filt}/bitcoin.qrc/" -i 'src/Makefile.qt.include'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"

	cd "${S}"
	eautoreconf
}

src_configure() {
	local my_econf=

	if use upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	if use wallet; then
		my_econf="${my_econf} --enable-wallet"
	else
		my_econf="${my_econf} --disable-wallet"
	fi
	my_econf="${my_econf} --with-system-leveldb"
	econf \
		--disable-ccache \
		--disable-static \
		--without-libs    \
		--without-utils    \
		--without-daemon  \
		${my_econf}  \
		$(use_with dbus qtdbus)  \
		$(use_with qrcode qrencode)  \
		--with-gui=$(usex qt5 qt5 qt4)
		"$@"
}

src_compile() {
	local OPTS=()

	OPTS+=("CXXFLAGS=${CXXFLAGS} -I$(db_includedir "${DB_VER}")")
	OPTS+=("LDFLAGS=${LDFLAGS} -ldb_cxx-${DB_VER}")

	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)

	cd src || die
	emake CXX="$(tc-getCXX)" "${OPTS[@]}"
	mv qt/bitcoin-qt ${PN}
}

src_install() {
	local my_topdir="/var/lib/bitcoinxt"
	local my_data="${my_topdir}/.bitcoin"

	dobin src/${PN}

	insinto "${my_data}"
	if [ -f "${ROOT}${my_data}/bitcoin.conf" ]; then
		elog "${EROOT}${my_data}/bitcoin.conf already installed - not overwriting it"
	else
		doins "${FILESDIR}/bitcoin.conf"
		elog "default ${EROOT}${my_data}/bitcoin.conf installed - you will need to edit it"
		fowners bitcoinxt:bitcoinxt "${my_data}/bitcoin.conf"
		fperms 400 "${my_data}/bitcoin.conf"
	fi

	keepdir "${my_data}"
	fperms 700 "${my_topdir}"
	fowners bitcoinxt:bitcoinxt "${my_topdir}"
	fowners bitcoinxt:bitcoinxt "${my_data}"

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	make_desktop_entry "${PN} %u" "BitcoinXT-Qt" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

	if use kde; then
		insinto /usr/share/kde4/services
		doins contrib/debian/bitcoin-qt.protocol
	fi

	if use doc; then
		dodoc README.md
		dodoc doc/release-notes.md
		dodoc doc/assets-attribution.md doc/bips.md doc/tor.md
		doman contrib/debian/manpages/bitcoin-qt.1
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoinxtd.logrotate" bitcoinxtd
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
