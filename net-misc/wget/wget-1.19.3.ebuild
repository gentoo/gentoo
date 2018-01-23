# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="https://www.gnu.org/software/wget/"
SRC_URI="mirror://gnu/wget/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug gnutls idn ipv6 libressl nls ntlm pcre +ssl static test uuid zlib"
REQUIRED_USE=" ntlm? ( !gnutls ssl ) gnutls? ( ssl )"

# Force a newer libidn2 to avoid libunistring deps. #612498
LIB_DEPEND="
	idn? ( >=net-dns/libidn2-0.14[static-libs(+)] )
	pcre? ( dev-libs/libpcre[static-libs(+)] )
	ssl? (
		gnutls? ( net-libs/gnutls:0=[static-libs(+)] )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0=[static-libs(+)] )
			libressl? ( dev-libs/libressl[static-libs(+)] )
		)
	)
	uuid? ( sys-apps/util-linux[static-libs(+)] )
	zlib? ( sys-libs/zlib[static-libs(+)] )
"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="
	${RDEPEND}
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
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS MAILING-LIST NEWS README doc/sample.wgetrc )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# revert some hack that breaks linking, bug #585924
	if [[ ${CHOST} == *-darwin* ]] \
	|| [[ ${CHOST} == *-solaris* ]] \
	|| [[ ${CHOST} == *-uclibc* ]] \
	|| [[ ${CHOST} == *-cygwin* ]] \
	; then
		sed -i \
			-e 's/^  LIBICONV=$/:/' \
			configure || die
	fi
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

	# There is no flag that controls this.  libunistring-prefix only
	# controls the search path (which is why we turn it off below).
	# Further, libunistring is only needed w/older libidn2 installs,
	# and since we force the latest, we can force off libunistring. #612498
	local myeconfargs=(
		--disable-assert
		--disable-rpath
		--without-included-libunistring
		--without-libunistring-prefix
		$(use_enable debug)
		$(use_enable idn iri)
		$(use_enable ipv6)
		$(use_enable nls)
		$(use_enable ntlm)
		$(use_enable pcre)
		$(use_enable ssl digest)
		$(use_enable ssl opie)
		$(use_with idn libidn)
		$(use_with ssl ssl $(usex gnutls gnutls openssl))
		$(use_with uuid libuuid)
		$(use_with zlib)
	)
	ac_cv_libunistring=no \
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	sed -i \
		-e "s:/usr/local/etc:${EPREFIX}/etc:g" \
		"${ED%/}"/etc/wgetrc \
		"${ED%/}"/usr/share/man/man1/wget.1 \
		"${ED%/}"/usr/share/info/wget.info \
		|| die
}
