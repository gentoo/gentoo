# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Full screen visualization of the network traffic"
HOMEPAGE="http://soft.risp.ru/trafshow/index_en.shtml"
SRC_URI="ftp://ftp.nsk.su/pub/RinetSoftware/${P}.tgz"

LICENSE="BSD"
SLOT="3"
KEYWORDS="amd64 ~hppa ~ppc ppc64 sparc x86"
IUSE="slang"

DEPEND="
	net-libs/libpcap
	!slang? ( sys-libs/ncurses )
	slang? ( >=sys-libs/slang-1.4 )
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${P}-gcc44.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-pcap_init.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default
	cat /usr/share/aclocal/pkg.m4 >> aclocal.m4 || die
	eautoreconf
}

src_configure() {
	if ! use slang; then
		# No command-line option so pre-cache instead
		export ac_cv_have_curses=ncurses
		export LIBS=-lncurses
	fi

	default
}
