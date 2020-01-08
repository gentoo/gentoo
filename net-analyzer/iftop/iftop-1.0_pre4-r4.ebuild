# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="display bandwidth usage on an interface"
SRC_URI="http://www.ex-parrot.com/pdw/iftop/download/${P/_/}.tar.gz"
HOMEPAGE="http://www.ex-parrot.com/pdw/iftop/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.0_pre4-configure.ac.patch
	"${FILESDIR}"/${PN}-1.0_pre4-Makefile.am.patch
	"${FILESDIR}"/${PN}-1.0_pre4-tsent-set-but-not-used.patch
	"${FILESDIR}"/${PN}-1.0_pre4-ip6.arpa.patch
	"${FILESDIR}"/${PN}-1.0_pre4-fix-MAC-formatting.patch
)
S="${WORKDIR}"/${P/_/}

src_prepare() {
	default
	# bug 490168
	cat "${FILESDIR}"/ax_pthread.m4 >> "${S}"/acinclude.m4 || die

	eautoreconf
}

src_install() {
	dosbin iftop
	doman iftop.8

	dodoc AUTHORS ChangeLog README "${FILESDIR}"/iftoprc
}
