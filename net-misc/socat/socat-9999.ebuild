# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="Multipurpose relay (SOcket CAT)"
HOMEPAGE="http://www.dest-unreach.org/socat/"
MY_P=${P/_beta/-b}
S="${WORKDIR}/${MY_P}"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="libressl ssl readline ipv6 tcpd"

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	readline? ( sys-libs/readline:= )
	tcpd? ( sys-apps/tcp-wrappers )
"
DEPEND="
	${RDEPEND}
	app-text/yodl
"

RESTRICT="test
	ssl? ( readline? ( bindist ) )"

DOCS=(
	BUGREPORTS CHANGES DEVELOPMENT EXAMPLES FAQ FILES PORTING README SECURITY
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.3.0-filan-build.patch
	"${FILESDIR}"/${PN}-1.7.3.1-stddef_h.patch
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
