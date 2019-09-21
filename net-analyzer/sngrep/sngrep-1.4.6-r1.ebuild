# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Ncurses SIP Messages flow viewer"
HOMEPAGE="https://github.com/irontec/sngrep"
SRC_URI="${HOMEPAGE}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eep gnutls ipv6 openssl pcre unicode"
REQUIRED_USE="
	gnutls? ( !openssl )
"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0=[unicode?]
	openssl? ( dev-libs/openssl:0= )
	gnutls? ( net-libs/gnutls )
"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable eep) \
		$(use_enable ipv6) \
		$(use_enable unicode) \
		$(use_with gnutls) \
		$(use_with openssl) \
		$(use_with pcre)
}
