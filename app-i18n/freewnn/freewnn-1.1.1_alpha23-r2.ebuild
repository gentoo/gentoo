# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

MY_P="FreeWnn-${PV/_alpha/-a0}"

DESCRIPTION="Network-Extensible Kana-to-Kanji Conversion System"
HOMEPAGE="http://freewnn.sourceforge.jp/ http://www.freewnn.org/"
SRC_URI="mirror://sourceforge.jp/${PN}/63271/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="+uum"

RDEPEND="
	sys-apps/tcp-wrappers
	virtual/libcrypt:=
	uum? ( sys-libs/ncurses:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-uum-EUC-JP.patch
	"${FILESDIR}"/${PN}-Wformat-security.patch
	"${FILESDIR}"/${PN}-1.1.1-implicit-configure.patch
)

# linked for tests which we skip
QA_CONFIG_IMPL_DECL_SKIP=( hosts_access )

src_prepare() {
	sed -i \
		-e "s/WNNOWNER = wnn/WNNOWNER = root/" \
		-e "s|@mandir@/|@mandir@/ja/|" \
		-e "s/@INSTPGMFLAGS@//" \
		makerule.mk.in || die

	# bug #542534
	sed -i \
		-e "s/egrep -v/grep -Eav/" \
		PubdicPlus/Makefile.in \
		Wnn/pubdicplus/Makefile.in \
		cWnn/[ct]dic/Makefile.in \
		kWnn/kdic/Makefile.in  || die

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable uum client)
		--enable-ipv6
		--disable-cWnn
		--disable-kWnn
		--disable-traditional-layout
		--enable-static # needed for correct compilation
		--with-term-libs="$( $(tc-getPKG_CONFIG) --libs ncurses )"
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	local m
	for m in $(find Wnn/man -name "*.man"); do
		iconv --from-code=EUC-JP --to-code=UTF-8 --output="${m}".UTF-8 "${m}" || die
		mv "${m}"{.UTF-8,} || die
	done
}

src_install() {
	emake DESTDIR="${ED}" install install.man

	find "${ED}" \( -name "*.la" -o -name "*.a" \) -delete || die

	local DOCS=( ChangeLog* CONTRIBUTORS )
	einstalldocs

	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
}
