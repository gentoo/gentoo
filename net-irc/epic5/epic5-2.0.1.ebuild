# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby23 ruby24 ruby25"

inherit autotools ruby-single toolchain-funcs

DESCRIPTION="Epic5 IRC Client"
SRC_URI="ftp://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/${P}.tar.xz"
HOMEPAGE="http://epicsol.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

# Fails to build without ipv6
IUSE="archive perl tcl ruby socks5 valgrind" #ipv6

RDEPEND="
	>=dev-libs/openssl-0.9.8e-r3:0=
	>=sys-libs/ncurses-5.6-r2:0=
	virtual/libiconv
	archive? ( app-arch/libarchive )
	perl? ( >=dev-lang/perl-5.8.8-r2:= )
	tcl? ( dev-lang/tcl:0= )
	socks5? ( net-proxy/dante )
	ruby? ( ${RUBY_DEPS} )
"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
"

S="${WORKDIR}/${P}"

PATCHES=(
	# From Debian
	"${FILESDIR}/${P}-openssl-1.1.patch"
)

src_configure() {
	# Because of our REQUIRED_USE constraints above, we know that
	# ruby_get_use_implementations will only ever return one ruby
	# implementation.
	econf \
		--libexecdir="${EPREFIX}"/usr/lib/misc \
		--with-ipv6 \
		$(use_with archive libarchive) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with socks5) \
		$(use_with tcl tcl "${EPREFIX}"/usr/$(get_libdir)/tclConfig.sh) \
		$(use_with valgrind valgrind)
}

src_compile() {
	# parallel build failure
	emake -j1
}

src_install () {
	default

	dodoc BUG_FORM COPYRIGHT EPIC4-USERS-README README KNOWNBUGS VOTES

	cd "${S}"/doc || die
	docinto doc
	dodoc \
		*.txt colors EPIC* IRCII_VERSIONS missing \
		nicknames outputhelp README.SSL SILLINESS TS4
}
