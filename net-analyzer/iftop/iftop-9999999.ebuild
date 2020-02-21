# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="display bandwidth usage on an interface"
HOMEPAGE="http://www.ex-parrot.com/pdw/iftop/"
EGIT_REPO_URI="https://code.blinkace.com/pdw/iftop"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
S="${WORKDIR}"/${P/_/}
PATCHES=(
	"${FILESDIR}"/${PN}-1.0_pre4-configure.ac.patch
	"${FILESDIR}"/${PN}-1.0_pre4-Makefile.am.patch
	"${FILESDIR}"/${PN}-1.0_pre4-fix-MAC-formatting.patch
	"${FILESDIR}"/${PN}-1.0_pre4-fno-common.patch
)

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
