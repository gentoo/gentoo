# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GENTOO_DEPEND_ON_PERL="no"

inherit perl-module

# Keep for _rc compability
MY_P="${P/_/-}"

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="https://irssi.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV/_/-}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="otr +perl selinux socks5 +proxy"

COMMON_DEPEND="
	sys-libs/ncurses:0=
	>=dev-libs/glib-2.6.0
	dev-libs/openssl:=
	otr? ( >=dev-libs/libgcrypt-1.2.0:0=
		>=net-libs/libotr-4.1.0 )
	perl? ( dev-lang/perl:= )
	socks5? ( >=net-proxy/dante-1.1.18 )"

DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig"

RDEPEND="
	${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-irc )"

RESTRICT="test"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# Disable automagic dependency on dev-libs/libutf8proc (bug #677804)
	export ac_cv_lib_utf8proc_utf8proc_version=no

	local myeconfargs=(
		--with-perl-lib=vendor
		--enable-true-color
		$(use_with otr)
		$(use_with proxy)
		$(use_with perl)
		$(use_with socks5 socks)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use perl && perl_delete_localpod
	rm -f "${ED}"/usr/$(get_libdir)/irssi/modules/*.{a,la} || die
}
