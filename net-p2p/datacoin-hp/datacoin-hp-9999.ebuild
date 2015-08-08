# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit bash-completion-r1 git-2 eutils db-use systemd user

MyPV="${PV/_/-}"
MyPN="${PN/-hp/d}"
MyP="primecoin-${MyPV}"

DESCRIPTION="High-performance version of datacoin (primecoin-hp fork)"
HOMEPAGE="https://github.com/foo1inge/datacoin-hp"
EGIT_REPO_URI="https://github.com/foo1inge/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples upnp ipv6 examples logrotate hardened"

RDEPEND="
	dev-libs/boost[threads(+)]
	dev-libs/openssl:0[-bindist]
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	<=dev-libs/leveldb-1.12.0[-snappy]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
	net-p2p/bitcoind
"

S="${WORKDIR}/${MyP}-linux/src"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-sys_leveldb.patch
	rm -r src/leveldd

	if has_version '>=dev-libs/boost-1.52'; then
		sed -i 's/\(-l db_cxx\)/-l boost_chrono$(BOOST_LIB_SUFFIX) \1/' src/makefile.unix
	fi
}

pkg_setup() {
	local UG="${PN}"
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/datacoin "${UG}"
}

src_configure() {
	OPTS=()

	OPTS+=("DEBUGFLAGS=")
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=("LDFLAGS=${LDFLAGS}")

	if use upnp; then
		OPTS+=("USE_UPNP=1")
	else
		OPTS+=("USE_UPNP=")
	fi

	use ipv6 || OPTS+=("USE_IPV6=0")

	use hardened || OPTS+=("PIE=1")

	OPTS+=("USE_SYSTEM_LEVELDB=1")
	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	cd src || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" ${MyPN}
}

#Tests are broken with and without our primecoin-sys_leveldb.patch.
#When tests work, make sure to inherit toolchain-funcs
#src_test() {
#   cd src || die
#   emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" test_primecoin
#   ./test_primecoin || die 'Tests failed'
#}

src_install() {
	dobin src/${MyPN}

	insinto /etc/datacoin
	doins "${FILESDIR}/datacoin.conf"
	fowners ${PN}:${PN} /etc/datacoin/datacoin.conf
	fperms 600 /etc/datacoin/datacoin.conf

	newconfd "${FILESDIR}/datacoin.confd" ${PN}
	newinitd "${FILESDIR}/datacoin.initd" ${PN}
	systemd_dounit "${FILESDIR}/datacoin.service"

	keepdir /var/lib/datacoin/.datacoin
	fperms 700 /var/lib/datacoin
	fowners ${PN}:${PN} /var/lib/datacoin/
	fowners ${PN}:${PN} /var/lib/datacoin/.datacoin
	dosym /etc/datacoin/datacoin.conf /var/lib/datacoin/.datacoin/datacoin.conf

	dodoc doc/README.md doc/release-notes.md
	newman contrib/debian/manpages/bitcoind.1 ${MyPN}.1
	newman contrib/debian/manpages/bitcoin.conf.5 datacoin.conf.5

	sed -i -e 's/bitcoin/datacoin-hp/g' contrib/bitcoind.bash-completion
	newbashcomp contrib/bitcoind.bash-completion ${PN}.bash-completion

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,pyminer,spendfrom,tidy_datadir.sh,wallettools}
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/datacoind.logrotate" ${MyPN}
	fi
}
