# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use autotools eutils toolchain-funcs user systemd

DESCRIPTION="BitcoinXT crypto-currency wallet for automated services"
HOMEPAGE="https://github/bitcoinxt/bitcoinxt"
My_PV="${PV/\.0d/}D"
SRC_URI="https://github.com/bitcoinxt/bitcoinxt/archive/v${My_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+doc +ssl +logrotate +upnp +wallet"

OPENSSL_DEPEND="dev-libs/openssl:0[-bindist]"
WALLET_DEPEND="media-gfx/qrencode sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"

RDEPEND="
	app-shells/bash:0
	sys-apps/sed
	dev-libs/boost[threads(+)]
	dev-libs/glib:2
	dev-libs/crypto++
	ssl? ( ${OPENSSL_DEPEND} )
	logrotate? ( app-admin/logrotate )
	wallet? ( ${WALLET_DEPEND} )
	upnp? ( net-libs/miniupnpc )
	virtual/bitcoin-leveldb
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/bitcoinxt-${My_PV}"

pkg_setup() {
	local UG='bitcoinxt'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoinxt "${UG}"
}

src_prepare() {
	epatch "${FILESDIR}/9999-syslibs.patch"
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
		--with-daemon  \
		--without-gui     \
		${my_econf}  \
		"$@"
}

src_compile() {
	local OPTS=()

	OPTS+=("CXXFLAGS=${CXXFLAGS} -I$(db_includedir "${DB_VER}")")
	OPTS+=("LDFLAGS=${LDFLAGS} -ldb_cxx-${DB_VER}")

	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)

	cd src || die
	emake CXX="$(tc-getCXX)" "${OPTS[@]}" bitcoind
	mv bitcoind ${PN}
}

src_install() {
	local my_topdir="/var/lib/bitcoinxt"
	local my_data="${my_topdir}/.bitcoin"

	dobin src/${PN}

	insinto "${my_data}"
	if [ -f "${ROOT}${my_data}/bitcoin.conf" ]; then
		elog "${EROOT}${my_data}/bitcoin.conf already installed - not overwriting it"
	else
		elog "default ${EROOT}${my_data}/bitcoin.conf installed - you will need to edit it"
		newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
		fowners bitcoinxt:bitcoinxt "${my_data}/bitcoin.conf"
		fperms 400 "${my_data}/bitcoin.conf"
	fi

	newconfd "${FILESDIR}/bitcoinxt.confd" ${PN}
	newinitd "${FILESDIR}/bitcoinxt.initd" ${PN}
	systemd_dounit "${FILESDIR}/bitcoinxtd.service"

	keepdir "${my_data}"
	fperms 700 "${my_topdir}"
	fowners bitcoinxt:bitcoinxt "${my_topdir}"
	fowners bitcoinxt:bitcoinxt "${my_data}"

	if use doc; then
		dodoc README.md
		dodoc doc/release-notes.md
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoinxtd.logrotate" bitcoinxtd
	fi
}
