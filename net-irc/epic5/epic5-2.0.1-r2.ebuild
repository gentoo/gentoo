# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Epic5 IRC Client"
SRC_URI="ftp://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/${P}.tar.xz"
HOMEPAGE="http://epicsol.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"

# Fails to build without ipv6
IUSE="archive perl tcl socks5 valgrind" #ipv6

RDEPEND="
	>=dev-libs/openssl-0.9.8e-r3:0=
	>=sys-libs/ncurses-5.6-r2:0=
	virtual/libcrypt:=
	virtual/libiconv
	archive? ( app-arch/libarchive )
	perl? ( >=dev-lang/perl-5.8.8-r2:= )
	tcl? ( dev-lang/tcl:0= )
	socks5? ( net-proxy/dante )
"
DEPEND="${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"

S="${WORKDIR}/${P}"

PATCHES=(
	# From Debian
	"${FILESDIR}/${P}-openssl-1.1.patch"
)

src_configure() {
	econf \
		--libexecdir="${EPREFIX}"/usr/lib/misc \
		--with-ipv6 \
		--without-ruby \
		$(use_with archive libarchive) \
		$(use_with perl) \
		$(use_with socks5) \
		$(use_with tcl tcl "${EPREFIX}"/usr/$(get_libdir)/tclConfig.sh) \
		$(use_with valgrind)
}

src_compile() {
	# parallel build failure
	emake -j1
}

src_install() {
	default

	dodoc BUG_FORM COPYRIGHT EPIC4-USERS-README README KNOWNBUGS VOTES

	cd "${S}"/doc || die
	docinto doc
	dodoc \
		*.txt colors EPIC* IRCII_VERSIONS missing \
		nicknames outputhelp README.SSL SILLINESS TS4
}
