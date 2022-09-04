# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DB_VER="4.8"

inherit autotools db-use flag-o-matic systemd

MY_PV="${PV/_/-}"
MY_PN="litecoin"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="The offical daemon to run your own (full) Litecoin node"
HOMEPAGE="https://litecoin.org/"
SRC_URI="https://github.com/${MY_PN}-project/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 upnp +wallet"

# uses an internal leveldb API (MemEnv) which newer versions no longer expose
RDEPEND="
	acct-group/litecoin
	acct-user/litecoin
	dev-libs/boost:=
	<dev-libs/leveldb-1.23:=
	dev-libs/libevent:=[threads(+)]
	dev-libs/openssl:=[-bindist(-)]
	sys-libs/db:$(db_ver_to_slot ${DB_VER})[cxx]
	upnp? ( net-libs/miniupnpc:= )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-system-leveldb.patch )

src_prepare() {
	default
	rm -r src/leveldb || die
	eautoreconf
}

src_configure() {
	# To avoid executable GNU stack.
	append-ldflags -Wl,-z,noexecstack

	local myeconfargs=(
		$(use_enable wallet)
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable cpu_flags_x86_sse2 sse2)
		--disable-ccache
		--disable-static
		# tests are broken and segfault
		--disable-tests
		--with-system-leveldb
		--without-libs
		--with-daemon
		--without-gui
		--without-qrencode
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /etc/litecoin
	doins "${FILESDIR}"/litecoin.conf
	fowners litecoin:litecoin /etc/litecoin/litecoin.conf
	fperms 600 /etc/litecoin/litecoin.conf

	newconfd "${FILESDIR}"/litecoin.confd ${PN}
	newinitd "${FILESDIR}"/litecoin.initd-r1 ${PN}
	systemd_dounit "${FILESDIR}"/litecoin.service

	keepdir /var/lib/litecoin/.litecoin
	fperms 700 /var/lib/litecoin
	fowners litecoin:litecoin /var/lib/litecoin/
	fowners litecoin:litecoin /var/lib/litecoin/.litecoin
	dosym ../../../../etc/litecoin/litecoin.conf /var/lib/litecoin/.litecoin/litecoin.conf

	dodoc doc/README.md doc/release-notes.md

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/litecoind.logrotate litecoind
}
