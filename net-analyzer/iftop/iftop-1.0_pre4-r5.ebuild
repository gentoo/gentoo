# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Display bandwidth usage on an interface"
HOMEPAGE="http://www.ex-parrot.com/pdw/iftop/ https://code.blinkace.com/pdw/iftop"
SRC_URI="http://www.ex-parrot.com/pdw/iftop/download/${P/_/}.tar.gz"
S="${WORKDIR}"/${P/_/}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
# autoconf-archive for ax_pthread, bug #490168
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0_pre4-configure.ac.patch
	"${FILESDIR}"/${PN}-1.0_pre4-Makefile.am.patch
	"${FILESDIR}"/${PN}-1.0_pre4-tsent-set-but-not-used.patch
	"${FILESDIR}"/${PN}-1.0_pre4-ip6.arpa.patch
	"${FILESDIR}"/${PN}-1.0_pre4-fix-MAC-formatting.patch
	"${FILESDIR}"/${PN}-1.0_pre4-fno-common.patch
	"${FILESDIR}"/${PN}-1.0_pre4-allow-scales-beyond-1gbps.patch
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	dosbin iftop
	doman iftop.8

	dodoc AUTHORS ChangeLog README "${FILESDIR}"/iftoprc
}
