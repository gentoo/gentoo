# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

MY_P=${P/-/_}
DESCRIPTION="improved Whois Client"
HOMEPAGE="https://www.linux.it/~md/software/"
SRC_URI="mirror://debian/pool/main/w/whois/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="iconv idn nls"
RESTRICT="test" #59327

RDEPEND="iconv? ( virtual/libiconv )
	idn? ( net-dns/libidn )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-lang/perl-5
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.2-config-file.patch
)

src_prepare() {
	default
	if use nls ; then
		sed -i -e 's:#\(.*pos\):\1:' Makefile || die
	else
		sed -i -e '/ENABLE_NLS/s:define:undef:' config.h || die

		# don't generate po files when nls is disabled (bug #419889)
		sed -i -e '/^all:/s/ pos//' \
			-e '/^install:/s/ install-pos//' Makefile || die
	fi
}

src_configure() { :;} # expected no-op

src_compile() {
	unset HAVE_ICONV HAVE_LIBIDN
	use iconv && export HAVE_ICONV=1
	use idn && export HAVE_LIBIDN=1
	tc-export CC
	emake CFLAGS="${CFLAGS} ${CPPFLAGS}"
}

src_install() {
	emake BASEDIR="${ED}" prefix=/usr install
	insinto /etc
	doins whois.conf
	dodoc README debian/changelog

	if [[ ${USERLAND} != "GNU" ]]; then
		mv "${ED}"/usr/share/man/man1/{whois,mdwhois}.1 || die
		mv "${ED}"/usr/bin/{whois,mdwhois} || die
	fi
}
