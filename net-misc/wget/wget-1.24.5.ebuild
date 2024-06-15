# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/wget.asc
inherit flag-o-matic python-any-r1 toolchain-funcs unpacker verify-sig

DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="https://www.gnu.org/software/wget/"
SRC_URI="mirror://gnu/wget/${P}.tar.lz"
SRC_URI+=" verify-sig? ( mirror://gnu/wget/${P}.tar.lz.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="cookie-check debug gnutls idn ipv6 libproxy metalink nls ntlm pcre +ssl static test uuid zlib"
REQUIRED_USE="ntlm? ( !gnutls ssl ) gnutls? ( ssl )"
RESTRICT="!test? ( test )"

# * Force a newer libidn2 to avoid libunistring deps. #bug #612498
# * Metalink can use gpgme automagically (so let's always depend on it)
# for signed metalink resources.
LIB_DEPEND="
	cookie-check? ( net-libs/libpsl )
	idn? ( >=net-dns/libidn2-0.14:=[static-libs(+)] )
	libproxy? ( net-libs/libproxy )
	metalink? (
		app-crypt/gpgme
		media-libs/libmetalink
	)
	pcre? ( dev-libs/libpcre2[static-libs(+)] )
	ssl? (
		gnutls? ( net-libs/gnutls:=[static-libs(+)] )
		!gnutls? ( dev-libs/openssl:=[static-libs(+)] )
	)
	uuid? ( sys-apps/util-linux[static-libs(+)] )
	zlib? ( sys-libs/zlib[static-libs(+)] )
"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
BDEPEND="
	$(unpacker_src_uri_depends)
	app-arch/xz-utils
	dev-lang/perl
	sys-apps/texinfo
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		>=dev-perl/HTTP-Daemon-6.60.0
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-SSL
	)
	verify-sig? ( >=sec-keys/openpgp-keys-wget-20240415 )
"

DOCS=( AUTHORS MAILING-LIST NEWS README )

# gnulib FPs
QA_CONFIG_IMPL_DECL_SKIP=( unreachable MIN alignof static_assert fpurge )

PATCHES=(
	"${FILESDIR}"/${PN}-1.24.5-libproxy-no-debug.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}.tar.lz{,.sig}
	unpacker ${P}.tar.lz
}

src_prepare() {
	default
	sed -i -e "s:/usr/local/etc:${EPREFIX}/etc:g" doc/{sample.wgetrc,wget.texi} || die
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
	# and since we force the latest, we can force off libunistring. # bug #612498
	local myeconfargs=(
		ac_cv_libunistring=no
		--disable-assert
		--disable-pcre
		--disable-rpath
		--without-included-libunistring
		--without-libunistring-prefix
		$(use_enable debug)
		$(use_enable idn iri)
		$(use_enable ipv6)
		$(use_enable nls)
		$(use_enable ntlm)
		$(use_enable pcre pcre2)
		$(use_enable ssl digest)
		$(use_enable ssl opie)
		$(use_with cookie-check libpsl)
		$(use_enable idn iri)
		$(use_enable libproxy)
		$(use_with metalink)
		$(use_with ssl ssl $(usex gnutls gnutls openssl))
		$(use_with uuid libuuid)
		$(use_with zlib)
	)

	econf "${myeconfargs[@]}"
}
