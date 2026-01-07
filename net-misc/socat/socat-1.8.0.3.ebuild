# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs

MY_P=${P/_beta/-b}
DESCRIPTION="Multipurpose relay (SOcket CAT)"
HOMEPAGE="http://www.dest-unreach.org/socat/ https://repo.or.cz/socat.git"
SRC_URI="http://www.dest-unreach.org/socat/download/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="ipv6 readline ssl tcpd"
# bug #946404 (and many others), whack-a-mole with timeouts and friends
# Try again in the future.
RESTRICT="test"

DEPEND="
	ssl? ( >=dev-libs/openssl-3:= )
	readline? ( sys-libs/readline:= )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}"

DOCS=( BUGREPORTS CHANGES DEVELOPMENT EXAMPLES FAQ FILES PORTING README SECURITY )

src_configure() {
	# bug #293324
	filter-flags '-Wno-error*'

	tc-export AR

	local myeconfargs=(
		$(use_enable ssl openssl)
		$(use_enable readline)
		$(use_enable ipv6 ip6)
		$(use_enable tcpd libwrap)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Most tests are skipped because they need network access or a TTY
	# Some are for /dev permissions probing (bug #940740)
	# 518 519 need extra permissions
	edo ./test.sh -v --expect-fail 13,15,87,217,311,313,370,388,410,466,478,518,519,528
}

src_install() {
	default

	docinto html
	dodoc doc/*.html doc/*.css

	if use elibc_musl; then
		QA_CONFIG_IMPL_DECL_SKIP=( getprotobynumber_r )
	fi
}
