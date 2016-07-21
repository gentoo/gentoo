# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit autotools db-use eutils flag-o-matic systemd user

MyPV="${PV/_/-}"
MyPN="litecoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="P2P Internet currency based on Bitcoin but easier to mine"
HOMEPAGE="https://litecoin.org/"
SRC_URI="https://github.com/${MyPN}-project/${MyPN}/archive/v${MyPV}.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logrotate upnp +wallet"

RDEPEND="
	dev-libs/boost[threads(+)]
	dev-libs/openssl:0[-bindist]
	logrotate? ( app-admin/logrotate )
	upnp? ( net-libs/miniupnpc )
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	>=dev-libs/leveldb-1.18-r1
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

S="${WORKDIR}/${MyP}"

pkg_setup() {
	local UG='litecoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/litecoin "${UG}"
}

src_prepare() {
	epatch "${FILESDIR}"/0.9.0-sys_leveldb.patch
	epatch "${FILESDIR}"/litecoind-0.10.2.2-memenv_h.patch
	epatch "${FILESDIR}"/litecoin-miniupnpc-abi.patch
	epatch "${FILESDIR}"/litecoind-0.10.2.2-fix-gnustack.patch
	eautoreconf
	rm -r src/leveldb
}

src_configure() {
	# To avoid executable GNU stack.
	append-ldflags -Wl,-z,noexecstack

	local my_econf=
	if use upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	econf \
		$(use_enable wallet)\
		--disable-ccache \
		--disable-static \
		--disable-tests \
		--with-system-leveldb \
		--with-system-libsecp256k1  \
		--without-libs \
		--with-daemon  \
		--without-gui     \
		--without-qrencode \
		${my_econf}
}

src_install() {
	default

	insinto /etc/litecoin
	doins "${FILESDIR}/litecoin.conf"
	fowners litecoin:litecoin /etc/litecoin/litecoin.conf
	fperms 600 /etc/litecoin/litecoin.conf

	newconfd "${FILESDIR}/litecoin.confd" ${PN}
	newinitd "${FILESDIR}/litecoin.initd-r1" ${PN}
	systemd_dounit "${FILESDIR}/litecoin.service"

	keepdir /var/lib/litecoin/.litecoin
	fperms 700 /var/lib/litecoin
	fowners litecoin:litecoin /var/lib/litecoin/
	fowners litecoin:litecoin /var/lib/litecoin/.litecoin
	dosym /etc/litecoin/litecoin.conf /var/lib/litecoin/.litecoin/litecoin.conf

	dodoc doc/README.md doc/release-notes.md
	newman contrib/debian/manpages/bitcoind.1 litecoind.1
	newman contrib/debian/manpages/bitcoin.conf.5 litecoin.conf.5

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/litecoind.logrotate" litecoind
	fi
}
