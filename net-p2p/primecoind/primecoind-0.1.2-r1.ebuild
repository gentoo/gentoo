# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/primecoind/primecoind-0.1.2-r1.ebuild,v 1.3 2014/08/28 22:42:59 blueness Exp $

EAPI=5

DB_VER="4.8"

inherit bash-completion-r1 db-use eutils systemd user

MyPV="${PV/_/-}"
MyPN="primecoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="P2P Internet currency based on Bitcoin but easier to mine"
HOMEPAGE="http://primecoin.org/"
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
	<=dev-libs/leveldb-1.12.0[-snappy]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

S="${WORKDIR}/${MyP}-linux/src"

pkg_setup() {
	local UG='primecoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/primecoin "${UG}"
}

src_prepare() {
	epatch "${FILESDIR}"/${MyPN}-sys_leveldb.patch
	rm -r src/leveldb

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

#Tests are broken with and without our primecoin-sys_leveldb.patch.
#When tests work, make sure to inherit toolchain-funcs
#src_test() {
#	cd src || die
#	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" test_primecoin
#	./test_primecoin || die 'Tests failed'
#}

src_install() {
	dobin src/${PN}

	insinto /etc/primecoin
	doins "${FILESDIR}/primecoin.conf"
	fowners primecoin:primecoin /etc/primecoin/primecoin.conf
	fperms 600 /etc/primecoin/primecoin.conf

	newconfd "${FILESDIR}/primecoin.confd" ${PN}
	newinitd "${FILESDIR}/primecoin.initd-r1" ${PN}
	systemd_dounit "${FILESDIR}/primecoin.service"

	keepdir /var/lib/primecoin/.primecoin
	fperms 700 /var/lib/primecoin
	fowners primecoin:primecoin /var/lib/primecoin/
	fowners primecoin:primecoin /var/lib/primecoin/.primecoin
	dosym /etc/primecoin/primecoin.conf /var/lib/primecoin/.primecoin/primecoin.conf

	dodoc doc/README.md doc/release-notes.md
	newman contrib/debian/manpages/bitcoind.1 primecoind.1
	newman contrib/debian/manpages/bitcoin.conf.5 primecoin.conf.5

	sed -i -e 's/bitcoin/primecoin/g' contrib/bitcoind.bash-completion
	newbashcomp contrib/bitcoind.bash-completion ${PN}.bash-completion

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,pyminer,spendfrom,tidy_datadir.sh,wallettools}
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/primecoind.logrotate" primecoind
	fi
}
