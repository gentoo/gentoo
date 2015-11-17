# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
PYTHON_COMPAT=( python{3_3,3_4} )

inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="https://www.gnu.org/software/wget/"
SRC_URI="mirror://gnu/wget/${P}.tar.xz
	http://git.savannah.gnu.org/cgit/wget.git/patch/?id=2cfcadf5e6d5c444765aa460915ae27109a8dbce -> ${PN}-1.17-fix_disabled_ipv6.patch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug gnutls idn ipv6 libressl nls ntlm pcre +ssl static test uuid zlib"
REQUIRED_USE=" ntlm? ( !gnutls ssl ) gnutls? ( ssl )"

LIB_DEPEND="idn? ( net-dns/libidn[static-libs(+)] )
	pcre? ( dev-libs/libpcre[static-libs(+)] )
	ssl? (
		gnutls? ( net-libs/gnutls[static-libs(+)] )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0[static-libs(+)] )
			libressl? ( dev-libs/libressl[static-libs(+)] )
		)
	)
	uuid? ( sys-apps/util-linux[static-libs(+)] )
	zlib? ( sys-libs/zlib[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	static? ( ${LIB_DEPEND} )
	test? (
		${PYTHON_DEPS}
		dev-lang/perl
		dev-perl/HTTP-Daemon
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-SSL
	)
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS MAILING-LIST NEWS README doc/sample.wgetrc )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	epatch "${DISTDIR}"/${P}-fix_disabled_ipv6.patch
}

src_configure() {
	# fix compilation on Solaris, we need filio.h for FIONBIO as used in
	# the included gnutls -- force ioctl.h to include this header
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DBSD_COMP=1

	if use static ; then
		append-ldflags -static
		tc-export PKG_CONFIG
		PKG_CONFIG+=" --static"
	fi
	econf \
		--disable-assert \
		--disable-rpath \
		$(use_with ssl ssl $(usex gnutls gnutls openssl)) \
		$(use_enable ssl opie) \
		$(use_enable ssl digest) \
		$(use_enable idn iri) \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_enable ntlm) \
		$(use_enable pcre) \
		$(use_enable debug) \
		$(use_with uuid libuuid) \
		$(use_with zlib)
}

src_test() {
	emake check
}

src_install() {
	default

	sed -i \
		-e "s:/usr/local/etc:${EPREFIX}/etc:g" \
		"${ED}"/etc/wgetrc \
		"${ED}"/usr/share/man/man1/wget.1 \
		"${ED}"/usr/share/info/wget.info
}
