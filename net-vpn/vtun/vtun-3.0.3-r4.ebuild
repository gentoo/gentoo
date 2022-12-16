# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="Create tunnels over TCP/IP networks with shaping, encryption, and compression"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://vtun.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"
IUSE="lzo socks5 ssl zlib"

RDEPEND="
	lzo? ( dev-libs/lzo:2 )
	socks5? ( net-proxy/dante )
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib )
	dev-libs/libbsd"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/bison"

DOCS=( ChangeLog Credits FAQ README README.Setup README.Shaper TODO )
CONFIG_CHECK="~TUN"

PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	# remove unneeded checking for /etc/vtund.conf
	"${FILESDIR}"/${PN}-3.0.2-remove-config-presence-check.patch
	# GCC 5 compatibility, patch from https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=778164
	"${FILESDIR}"/${P}-gcc5.patch
	# openssl 1.1 compatibility, bug 674280
	"${FILESDIR}"/${PN}-libssl-1.1.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-C99-inline.patch
)

src_prepare() {
	default
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
