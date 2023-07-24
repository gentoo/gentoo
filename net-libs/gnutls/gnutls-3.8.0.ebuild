# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/gnutls.asc
inherit libtool multilib-minimal verify-sig

DESCRIPTION="A secure communications library implementing the SSL, TLS and DTLS protocols"
HOMEPAGE="https://www.gnutls.org/"
SRC_URI="mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz"
SRC_URI+=" verify-sig? ( mirror://gnupg/gnutls/v$(ver_cut 1-2)/${P}.tar.xz.sig )"

LICENSE="GPL-3 LGPL-2.1+"
# As of 3.8.0, the C++ library is header-only, but we won't drop the subslot
# component for it until libgnutls.so breaks ABI, to avoid pointless rebuilds.
# Subslot format:
# <libgnutls.so number>.<libgnutlsxx.so number>
SLOT="0/30.30"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="brotli +cxx dane doc examples +idn nls +openssl pkcs11 seccomp sslv2 sslv3 static-libs test test-full +tls-heartbeat tools zlib zstd"
REQUIRED_USE="test-full? ( cxx dane doc examples idn nls openssl pkcs11 seccomp tls-heartbeat tools )"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/libtasn1-4.9:=[${MULTILIB_USEDEP}]
	dev-libs/libunistring:=[${MULTILIB_USEDEP}]
	>=dev-libs/nettle-3.6:=[gmp,${MULTILIB_USEDEP}]
	>=dev-libs/gmp-5.1.3-r1:=[${MULTILIB_USEDEP}]
	brotli? ( >=app-arch/brotli-1.0.0:=[${MULTILIB_USEDEP}] )
	dane? ( >=net-dns/unbound-1.4.20:=[${MULTILIB_USEDEP}] )
	nls? ( >=virtual/libintl-0-r1:=[${MULTILIB_USEDEP}] )
	pkcs11? ( >=app-crypt/p11-kit-0.23.1[${MULTILIB_USEDEP}] )
	idn? ( >=net-dns/libidn2-0.16-r1:=[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	zstd? ( >=app-arch/zstd-1.3.0:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? (
		seccomp? ( sys-libs/libseccomp )
	)"
BDEPEND="
	dev-util/gtk-doc-am
	>=virtual/pkgconfig-0-r1
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	test-full? (
		app-crypt/dieharder
		>=app-misc/datefudge-1.22
		dev-libs/softhsm:2[-bindist(-)]
		net-dialup/ppp
		net-misc/socat
	)
	verify-sig? ( >=sec-keys/openpgp-keys-gnutls-20221017 )"

DOCS=( README.md doc/certtool.cfg )

HTML_DOCS=()

src_prepare() {
	default

	# bug #520818
	export TZ=UTC

	use doc && HTML_DOCS+=( doc/gnutls.html )

	# don't try to use system certificate store on macOS, it is
	# confusingly ignoring our ca-certificates and more importantly
	# fails to compile in certain configurations
	sed -i -e 's/__APPLE__/__NO_APPLE__/' lib/system/certs.c || die

	# Use sane .so versioning on FreeBSD.
	elibtoolize
}

multilib_src_configure() {
	LINGUAS="${LINGUAS//en/en@boldquot en@quot}"

	local libconf=()

	# TPM needs to be tested before being enabled
	# Note that this may add a libltdl dep when enabled. Check configure.ac.
	libconf+=(
		--without-tpm
		--without-tpm2
	)

	# hardware-accel is disabled on OSX because the asm files force
	#   GNU-stack (as doesn't support that) and when that's removed ld
	#   complains about duplicate symbols
	[[ ${CHOST} == *-darwin* ]] && libconf+=( --disable-hardware-acceleration )

	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	local myeconfargs=(
		--disable-valgrind-tests
		$(multilib_native_enable manpages)
		$(multilib_native_use_enable doc gtk-doc)
		$(multilib_native_use_enable doc)
		$(multilib_native_use_enable seccomp seccomp-tests)
		$(multilib_native_use_enable test tests)
		$(multilib_native_use_enable test-full full-test-suite)
		$(multilib_native_use_enable tools)
		$(use_enable cxx)
		$(use_enable dane libdane)
		$(use_enable nls)
		$(use_enable openssl openssl-compatibility)
		$(use_enable sslv2 ssl2-support)
		$(use_enable sslv3 ssl3-support)
		$(use_enable static-libs static)
		$(use_enable tls-heartbeat heartbeat-support)
		$(use_with brotli)
		$(use_with idn)
		$(use_with pkcs11 p11-kit)
		$(use_with zlib)
		$(use_with zstd)
		--disable-rpath
		--with-default-trust-store-file="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		--with-unbound-root-key-file="${EPREFIX}"/etc/dnssec/root-anchors.txt
		--without-included-libtasn1
		$("${S}/configure" --help | grep -o -- '--without-.*-prefix')
	)

	ECONF_SOURCE="${S}" econf "${libconf[@]}" "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
