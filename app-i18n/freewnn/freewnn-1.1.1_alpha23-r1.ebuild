# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

MY_P="FreeWnn-${PV/_alpha/-a0}"

DESCRIPTION="Network-Extensible Kana-to-Kanji Conversion System"
HOMEPAGE="http://freewnn.sourceforge.jp/ http://www.freewnn.org/"
SRC_URI="mirror://sourceforge.jp/${PN}/63271/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv sparc x86"
IUSE="ipv6 uum"

RDEPEND="virtual/libcrypt:=
	uum? ( sys-libs/ncurses:= )"
DEPEND="${RDEPEND}
	uum? ( virtual/pkgconfig )"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-uum-EUC-JP.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
)
DOCS="ChangeLog* CONTRIBUTORS"

src_prepare() {
	sed -i \
		-e "s/WNNOWNER = wnn/WNNOWNER = root/" \
		-e "s|@mandir@/|@mandir@/ja/|" \
		-e "s/@INSTPGMFLAGS@//" \
		makerule.mk.in

	# bug #542534
	sed -i \
		-e "s/egrep -v/egrep -av/" \
		PubdicPlus/Makefile.in \
		Wnn/pubdicplus/Makefile.in \
		cWnn/[ct]dic/Makefile.in \
		kWnn/kdic/Makefile.in

	default
}

src_configure() {
	econf \
		$(use_enable uum client) \
		$(use_with ipv6) \
		--disable-cWnn \
		--disable-kWnn \
		--disable-traditional-layout \
		--with-term-libs="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_compile() {
	default

	local m
	for m in $(find Wnn/man -name "*.man"); do
		iconv -f EUC-JP -t UTF-8 "${m}" > "${m}".UTF-8 || die
		mv "${m}"{.UTF-8,} || die
	done
}

src_install() {
	emake DESTDIR="${D}" install install.man
	einstalldocs

	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
}
