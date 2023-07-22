# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info autotools

DESCRIPTION="Create tunnels over TCP/IP networks with shaping, encryption, and compression"
SRC_URI="https://sourceforge.net/projects/vtun/files/${PN}/${PV}/${P}.tar.gz"
HOMEPAGE="https://vtun.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc ~x86"
IUSE="lzo socks5 ssl zlib"

RDEPEND="
	lzo? ( dev-libs/lzo:2 )
	socks5? ( net-proxy/dante )
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib )
	dev-libs/libbsd"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	sys-devel/bison
"

DOCS=( ChangeLog Credits FAQ README README.Setup README.Shaper TODO )
CONFIG_CHECK="~TUN"

PATCHES=(
	"${FILESDIR}"/${P}-libssl-ctx.patch
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-naughty-inlines.patch
	"${FILESDIR}"/${P}-autoconf-fork-not-working.patch
	"${FILESDIR}"/${P}-use-bison-for-yacc.patch
)

src_prepare() {
	default
	eautoreconf
	sed -i -e '/^LDFLAGS/s|=|+=|g' Makefile.in || die
	sed -i 's:$(BIN_DIR)/strip $(DESTDIR)$(SBIN_DIR)/vtund::' Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable ssl) \
		$(use_enable zlib) \
		$(use_enable lzo) \
		$(use_enable socks5 socks) \
		--enable-shaper
}

src_install() {
	default
	newinitd "${FILESDIR}"/vtun.rc vtun
	insinto /etc
	doins "${FILESDIR}"/vtund-start.conf
	rm -r "${ED}"/var || die
}
