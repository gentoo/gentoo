# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils toolchain-funcs

DESCRIPTION="Clients for net-analyzer/argus"
HOMEPAGE="https://www.qosient.com/argus/"
SRC_URI="https://qosient.com/argus/dev/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug ft geoip mysql sasl tcpd"

MY_CDEPEND="
	net-analyzer/rrdtool[perl]
	net-libs/libpcap
	sys-libs/ncurses:=
	sys-libs/readline:=
	sys-libs/zlib
	ft? ( net-analyzer/flow-tools )
	geoip? ( dev-libs/geoip )
	mysql? ( virtual/mysql )
	sasl? ( dev-libs/cyrus-sasl )
"

RDEPEND="
	${MY_CDEPEND}
"

DEPEND="
	${MY_CDEPEND}
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.0.4.1-disable-tcp-wrappers-automagic.patch \
		"${FILESDIR}"/${PN}-3.0.7.21-curses-readline.patch

	sed -i -e 's| ar | $(AR) |g' common/Makefile.in || die
	tc-export AR RANLIB

	eautoreconf
}

src_configure() {
	use debug && touch .debug
	econf \
		$(use_with ft libft) \
		$(use_with geoip GeoIP /usr/) \
		$(use_with sasl) \
		$(use_with tcpd wrappers) \
		$(use_with mysql)
}

src_compile() {
	# racurses uses both libncurses and libtinfo, if present
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
