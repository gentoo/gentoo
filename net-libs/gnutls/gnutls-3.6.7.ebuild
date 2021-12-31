# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool multilib-minimal

DESCRIPTION="A TLS 1.2 and SSL 3.0 implementation for the GNU project"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-3 LGPL-2.1+"
SLOT="0/30" # libgnutls.so number
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv s390 ~sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+cxx dane doc examples guile +idn nls +openssl pkcs11 seccomp sslv2 sslv3 static-libs test test-full +tls-heartbeat tools valgrind"

REQUIRED_USE="
	test-full? ( cxx dane doc examples guile idn nls openssl pkcs11 seccomp tls-heartbeat tools )"
RESTRICT="!test? ( test )"

# NOTICE: sys-devel/autogen is required at runtime as we
# use system libopts
RDEPEND=">=dev-libs/libtasn1-4.9:=[${MULTILIB_USEDEP}]
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-3.4.1:=[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-5.1.3-r1:=[${MULTILIB_USEDEP}]
	tools? ( sys-devel/autogen:= )
	dane? ( >=net-dns/unbound-1.4.20:=[${MULTILIB_USEDEP}] )
	guile? ( >=dev-scheme/guile-2:=[networking] )
	nls? ( >=virtual/libintl-0-r1:=[${MULTILIB_USEDEP}] )
	pkcs11? ( >=app-crypt/p11-kit-0.23.1:=[${MULTILIB_USEDEP}] )
	idn? ( >=net-dns/libidn2-0.16-r1:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? (
		seccomp? ( sys-libs/libseccomp )
	)"
BDEPEND=">=virtual/pkgconfig-0-r1
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	tools? ( sys-devel/autogen )
	valgrind? ( dev-util/valgrind )
	test-full? (
		app-crypt/dieharder
		>=app-misc/datefudge-1.22
		dev-libs/softhsm:2[-bindist]
		net-dialup/ppp
		net-misc/socat
	)"

DOCS=(
	README.md
	doc/certtool.cfg
)

HTML_DOCS=()

pkg_setup() {
	# bug#520818
	export TZ=UTC

	use doc && HTML_DOCS+=(
		doc/gnutls.html
	)
}

src_prepare() {
	default

	# force regeneration of autogen-ed files
	local file
	for file in $(grep -l AutoGen-ed src/*.c) ; do
		rm src/$(basename ${file} .c).{c,h} || die
	done

	# Use sane .so versioning on FreeBSD.
	elibtoolize
}

multilib_src_configure() {
	LINGUAS="${LINGUAS//en/en@boldquot en@quot}"

	# TPM needs to be tested before being enabled
	libconf+=( --without-tpm )

	# hardware-accell is disabled on OSX because the asm files force
	#   GNU-stack (as doesn't support that) and when that's removed ld
	#   complains about duplicate symbols
	[[ ${CHOST} == *-darwin* ]] && libconf+=( --disable-hardware-acceleration )

	# Cygwin as does not understand these asm files at all
	[[ ${CHOST} == *-cygwin* ]] && libconf+=( --disable-hardware-acceleration )

	ECONF_SOURCE=${S} econf \
		$(multilib_native_enable manpages) \
		$(multilib_native_use_enable doc gtk-doc) \
		$(multilib_native_use_enable doc) \
		$(multilib_native_use_enable guile) \
		$(multilib_native_use_enable seccomp seccomp-tests) \
		$(multilib_native_use_enable test tests) \
		$(multilib_native_use_enable test-full full-test-suite) \
		$(multilib_native_use_enable tools) \
		$(multilib_native_use_enable valgrind valgrind-tests) \
		$(use_enable cxx) \
		$(use_enable dane libdane) \
		$(use_enable nls) \
		$(use_enable openssl openssl-compatibility) \
		$(use_enable sslv2 ssl2-support) \
		$(use_enable sslv3 ssl3-support) \
		$(use_enable static-libs static) \
		$(use_enable tls-heartbeat heartbeat-support) \
		$(use_with idn) \
		$(use_with pkcs11 p11-kit) \
		--disable-rpath \
		--with-unbound-root-key-file="${EPREFIX}/etc/dnssec/root-anchors.txt" \
		--without-included-libtasn1 \
		"${libconf[@]}" \
		$("${S}/configure" --help | grep -- '--without-.*-prefix' | sed -e 's/^ *\([^ ]*\) .*/\1/g')
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
