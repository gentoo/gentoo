# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="Clients for net-analyzer/argus"
HOMEPAGE="https://openargus.org/"
SRC_URI="https://qosient.com/argus/dev/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug ft geoip mysql sasl tcpd"

ARGUS_CDEPEND="
	net-analyzer/rrdtool[perl]
	net-libs/libpcap
	net-libs/libtirpc:=
	sys-libs/ncurses:=
	sys-libs/readline:=
	sys-libs/zlib
	ft? ( net-analyzer/flow-tools )
	geoip? ( dev-libs/geoip )
	mysql? ( dev-db/mysql-connector-c:0= )
	sasl? ( dev-libs/cyrus-sasl )
"
RDEPEND="
	${ARGUS_CDEPEND}
"
DEPEND="
	${ARGUS_CDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.4.1-disable-tcp-wrappers-automagic.patch
	"${FILESDIR}"/${PN}-3.0.7.21-curses-readline.patch
	"${FILESDIR}"/${PN}-3.0.8.2-ar.patch
	"${FILESDIR}"/${PN}-3.0.8.2-curses-readline.patch
	"${FILESDIR}"/${PN}-3.0.8.2-my_bool.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	tc-export AR RANLIB

	use debug && touch .debug
	econf \
		$(use_with ft libft) \
		$(use_with geoip GeoIP /usr/) \
		$(use_with sasl) \
		$(use_with tcpd wrappers) \
		$(use_with mysql mysql /usr)
}

src_compile() {
	emake \
		CCOPT="${CFLAGS} ${LDFLAGS}" \
		RANLIB=$(tc-getRANLIB) \
		CURSESLIB="$( $(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin bin/ra*
	dodoc ChangeLog CREDITS README CHANGES
	doman man/man{1,5}/*
}
