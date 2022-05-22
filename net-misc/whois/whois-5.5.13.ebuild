# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=${P/-/_}
DESCRIPTION="Improved Whois Client"
HOMEPAGE="https://github.com/rfc1036/whois"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rfc1036/whois.git"
else
	SRC_URI="mirror://debian/pool/main/w/whois/${MY_P}.tar.xz"
	#SRC_URI="https://github.com/rfc1036/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}

	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="iconv idn nls xcrypt"

RDEPEND="iconv? ( virtual/libiconv )
	idn? ( net-dns/libidn2:= )
	nls? ( virtual/libintl )
	xcrypt? ( >=sys-libs/libxcrypt-4.1:= )
	!xcrypt? ( virtual/libcrypt:= )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/xz-utils
	>=dev-lang/perl-5
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.2-config-file.patch
	"${FILESDIR}"/${PN}-5.3.0-libidn_automagic.patch
	"${FILESDIR}"/${PN}-5.5.6-libxcrypt_automagic.patch
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

src_configure() { :; } # expected no-op

src_compile() {
	unset HAVE_ICONV HAVE_LIBIDN

	use iconv && export HAVE_ICONV=1
	use idn && export HAVE_LIBIDN=1
	use xcrypt && export HAVE_XCRYPT=1

	tc-export CC

	emake CFLAGS="${CFLAGS} ${CPPFLAGS}"
}

src_install() {
	emake BASEDIR="${ED}" prefix=/usr install

	insinto /etc
	doins whois.conf
	dodoc README debian/changelog

	if ! use userland_GNU ; then
		mv "${ED}"/usr/share/man/man1/{whois,mdwhois}.1 || die
		mv "${ED}"/usr/bin/{whois,mdwhois} || die
	fi
}
