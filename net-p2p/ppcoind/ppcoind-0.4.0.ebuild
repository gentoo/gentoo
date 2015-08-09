# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use eutils systemd user

MyPV="${PV/_/-}"
MyPN="ppcoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="Cryptocurrency forked from Bitcoin which aims to be energy efficiency"
HOMEPAGE="http://peercoin.net/"
SRC_URI="mirror://sourceforge/${MyPN}/${MyP}-linux.tar.gz -> ${MyP}.tar.gz"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples ipv6 logrotate upnp"

RDEPEND="
	dev-libs/boost[threads(+)]
	dev-libs/openssl:0[-bindist]
	logrotate? (
		app-admin/logrotate
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

S="${WORKDIR}/${MyP}-linux/src"

pkg_setup() {
	local UG='ppcoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/ppcoin "${UG}"
}

src_prepare() {
	if has_version '>=dev-libs/boost-1.52'; then
		sed -i 's/\(-l db_cxx\)/-l boost_chrono$(BOOST_LIB_SUFFIX) \1/' src/makefile.unix
	fi
}

src_configure() {
	OPTS=()

	OPTS+=("DEBUGFLAGS=")
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=("LDFLAGS=${LDFLAGS}")

	if use upnp; then
		OPTS+=("USE_UPNP=1")
	else
		OPTS+=("USE_UPNP=-")
	fi

	use ipv6 || OPTS+=("USE_IPV6=-")

	OPTS+=("USE_SYSTEM_LEVELDB=1")
	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	cd src || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" ${PN}
}

#Tests are broken
#src_test() {
#	cd src || die
#	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" test_ppcoin
#	./test_ppcoin || die 'Tests failed'
#}

src_install() {
	dobin src/${PN}

	insinto /etc/ppcoin
	doins "${FILESDIR}/ppcoin.conf"
	fowners ppcoin:ppcoin /etc/ppcoin/ppcoin.conf
	fperms 600 /etc/ppcoin/ppcoin.conf

	newconfd "${FILESDIR}/ppcoin.confd" ${PN}
	newinitd "${FILESDIR}/ppcoin.initd-r1" ${PN}
	systemd_dounit "${FILESDIR}/ppcoin.service"

	keepdir /var/lib/ppcoin/.ppcoin
	fperms 700 /var/lib/ppcoin
	fowners ppcoin:ppcoin /var/lib/ppcoin/
	fowners ppcoin:ppcoin /var/lib/ppcoin/.ppcoin
	dosym /etc/ppcoin/ppcoin.conf /var/lib/ppcoin/.ppcoin/ppcoin.conf

	dodoc ../README
	dodoc README.md
	newman contrib/debian/manpages/bitcoind.1 ppcoind.1
	newman contrib/debian/manpages/bitcoin.conf.5 ppcoin.conf.5

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,gitian-descriptors,gitian-downloader,pyminer,wallettools}

	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/ppcoind.logrotate" ppcoind
	fi
}
