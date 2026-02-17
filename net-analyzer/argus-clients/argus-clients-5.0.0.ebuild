# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Clients for net-analyzer/argus"
HOMEPAGE="https://openargus.org/"
SRC_URI="https://github.com/openargus/clients/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/clients-${PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ares curl debug ft geoip geoip2 mysql pcre sasl tcpd"

RDEPEND="
	net-analyzer/rrdtool[perl]
	net-libs/libpcap
	net-libs/libtirpc:=
	sys-libs/ncurses:=
	sys-libs/readline:=
	virtual/zlib
	ares? ( net-dns/c-ares )
	curl? ( net-misc/curl )
	ft? ( net-analyzer/flow-tools )
	geoip? ( dev-libs/geoip )
	geoip2? ( dev-libs/libmaxminddb )
	mysql? ( dev-db/mysql-connector-c:0= )
	pcre? ( dev-libs/libpcre )
	sasl? ( dev-libs/cyrus-sasl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.8.3-configure-clang16.patch
	"${FILESDIR}"/${PN}-5.0.0-incompatible-pointer.patch
	"${FILESDIR}"/${PN}-5.0.0-curses-readline.patch
)

src_prepare() {
	default

	# Fix man
	mv man/man5/ramanage.conf.5.in man/man5/ramanage.conf.5

	eautoreconf
}

src_configure() {
	tc-export AR RANLIB

	use debug && touch .debug
	econf \
		$(use_with ares c-ares) \
		$(use_with curl libcurl) \
		$(use_with ft libft) \
		$(use_with geoip GeoIP /usr/) \
		$(use_with geoip2 libmaxminddb) \
		$(use_with sasl) \
		$(use_with mysql mysql /usr) \
		$(use_with pcre libpcre)
}

src_compile() {
	emake \
		CCOPT="${CFLAGS} ${LDFLAGS}" \
		RANLIB="$(tc-getRANLIB)" \
		CURSESLIB="$( $(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin bin/ra*
	dodoc ChangeLog CREDITS pkg/README CHANGES pkg/*.conf
	doman man/man{1,5,8}/*
}
