# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

MY_P=${P/_beta/-b}
DESCRIPTION="Multipurpose relay (SOcket CAT)"
HOMEPAGE="http://www.dest-unreach.org/socat/ https://repo.or.cz/socat.git"
SRC_URI="http://www.dest-unreach.org/socat/download/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="libressl ipv6 readline ssl tcpd"

DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	readline? ( sys-libs/readline:= )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}"

# Tests are a large bash script
# Hard to disable individual tests needing network or privileges
RESTRICT="
	test
	ssl? ( readline? ( bindist ) )
"

DOCS=( BUGREPORTS CHANGES DEVELOPMENT EXAMPLES FAQ FILES PORTING README SECURITY )

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.3.0-filan-build.patch
	"${FILESDIR}"/${PN}-1.7.3.1-stddef_h.patch
	"${FILESDIR}"/${PN}-1.7.3.4-fno-common.patch
	"${FILESDIR}"/${PN}-2.0.0_beta9-libressl.patch
)

pkg_setup() {
	# bug #587740
	if use readline && use ssl ; then
		elog "You are enabling both readline and openssl USE flags, the licenses"
		elog "for these packages conflict. You may not be able to legally"
		elog "redistribute the resulting binary."
	fi
}

src_prepare() {
	default

	touch doc/${PN}.1 || die

	eautoreconf
}

src_configure() {
	filter-flags -Wall '-Wno-error*' #293324
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
