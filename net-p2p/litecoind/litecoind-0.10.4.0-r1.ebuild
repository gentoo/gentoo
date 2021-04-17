# Copyright 1999-2021 Gentoo Authors
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
IUSE="logrotate upnp +wallet"

RDEPEND="
	acct-group/litecoin
	acct-user/litecoin
	dev-libs/boost:=[threads(+)]
	dev-libs/leveldb:=
	dev-libs/openssl:0[-bindist]
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	logrotate? ( app-admin/logrotate )
	upnp? ( net-libs/miniupnpc )
"
DEPEND="
	${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

PATCHES=(
	"${FILESDIR}"/0.9.0-sys_leveldb.patch
	"${FILESDIR}"/litecoind-0.10.2.2-memenv_h.patch
	"${FILESDIR}"/litecoind-0.10.2.2-fix-gnustack.patch
	"${FILESDIR}"/${P}-gcc6.patch
)

src_prepare() {
	default

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

	local myeconfargs=(
		$(use_enable wallet)
		--disable-ccache
		--disable-static
		--disable-tests
		--with-system-leveldb
		--with-system-libsecp256k1
		--without-libs
		--with-daemon
		--without-gui
		--without-qrencode
		${my_econf}
	)

	econf "${myeconfargs[@]}"
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
