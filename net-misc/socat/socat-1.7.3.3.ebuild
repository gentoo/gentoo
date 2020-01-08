# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Multipurpose relay (SOcket CAT)"
HOMEPAGE="http://www.dest-unreach.org/socat/"
MY_P=${P/_beta/-b}
S="${WORKDIR}/${MY_P}"
SRC_URI="http://www.dest-unreach.org/socat/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="bindist libressl ssl readline ipv6 tcpd"

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	readline? ( sys-libs/readline:= )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="
	${DEPEND}
"
RESTRICT="
	test
	ssl? ( readline? ( bindist ) )
"
DOCS=(
	BUGREPORTS CHANGES DEVELOPMENT EXAMPLES FAQ FILES PORTING README SECURITY
)

pkg_setup() {
	# bug #587740
	if use readline && use ssl; then
		elog "You are enabling both readline and openssl USE flags, the licenses"
		elog "for these packages conflict. You may not be able to legally"
		elog "redistribute the resulting binary."
	fi
}

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	filter-flags '-Wno-error*' #293324
	tc-export AR
	econf \
		$(use_enable ssl openssl) \
		$(use_enable readline) \
		$(use_enable ipv6 ip6) \
		$(use_enable tcpd libwrap)
}

src_install() {
	default

	docinto html
	dodoc doc/*.html doc/*.css
}
