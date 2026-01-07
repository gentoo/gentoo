# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_rc/-rc}
PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/icu.asc
inherit autotools flag-o-matic multilib-minimal python-any-r1 toolchain-funcs verify-sig

DESCRIPTION="International Components for Unicode"
HOMEPAGE="https://icu.unicode.org/"
SRC_URI="https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-sources.tgz"
SRC_URI+=" verify-sig? ( https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-sources.tgz.asc )"
S="${WORKDIR}"/${PN}/source

LICENSE="BSD"
SLOT="0/${PV%.*}"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
fi
IUSE="debug doc examples static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	dev-build/autoconf-archive
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
	verify-sig? ( >=sec-keys/openpgp-keys-icu-20241110 )
"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/icu-config
)

PATCHES=(
	"${FILESDIR}/${PN}-76.1-remove-bashisms.patch"
	"${FILESDIR}/${PN}-64.2-darwin.patch"
	"${FILESDIR}/${PN}-68.1-nonunicode.patch"

	# Undo change for now which exposes underlinking in consumers;
	# revisit when things are a bit quieter and tinderbox its removal.
	"${FILESDIR}/${PN}-76.1-undo-pkgconfig-change-for-now.patch"
	# https://unicode-org.atlassian.net/browse/ICU-23120
	"${FILESDIR}/${PN}-77.1-invalid-malloc.patch"
)

HTML_DOCS=( ../readme.html )

src_prepare() {
	default

	# TODO: switch uconfig.h hacks to use uconfig_local
	#
	# Disable renaming as it assumes stable ABI and that consumers
	# won't use unofficial APIs. We need this despite the configure argument.
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
		common/unicode/uconfig.h || die
	#
	# ODR violations, experimental API
	sed -i \
		-e "s/#   define UCONFIG_NO_MF2 0/#define UCONFIG_NO_MF2 1/" \
		common/unicode/uconfig.h || die

	# Fix linking of icudata
	sed -i \
		-e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" \
		config/mh-linux || die

	# Append doxygen configuration to configure
	sed -i \
		-e 's:icudefs.mk:icudefs.mk Doxyfile:' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	MAKEOPTS+=" VERBOSE=1"

	if tc-is-cross-compiler; then
		mkdir "${WORKDIR}"/host || die
		pushd "${WORKDIR}"/host >/dev/null || die

		CFLAGS="" CXXFLAGS="" ASFLAGS="" LDFLAGS="" \
		CC="$(tc-getBUILD_CC)" CXX="$(tc-getBUILD_CXX)" AR="$(tc-getBUILD_AR)" \
		RANLIB="$(tc-getBUILD_RANLIB)" LD="$(tc-getBUILD_LD)" \
		"${S}"/configure --disable-renaming --disable-debug \
			--disable-samples --enable-static || die
		emake

		popd >/dev/null || die
	fi

	# Workaround for bug #963337 (gcc PR122058)
	tc-is-gcc && [[ $(gcc-major-version) -eq 16 ]] && append-cxxflags -fno-devirtualize-speculatively

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# https://unicode-org.github.io/icu/userguide/icu4c/packaging
	local myeconfargs=(
		--disable-renaming
		--disable-samples
		# TODO: Re-enable(?) - planned to do this w/ 73.2 but seem to
		# get test failures only with --enable-layoutex.
		--disable-layoutex
		$(use_enable debug)
		$(use_enable static-libs static)
		$(use_enable test tests)
		$(multilib_native_use_enable examples samples)
	)

	#if use test ; then
	#	myeconfargs+=(
	#		--enable-extras
	#		--enable-tools
	#	)
	#else
	#	myeconfargs+=(
	#		$(multilib_native_enable extras)
	#		$(multilib_native_enable tools)
	#	)
	#fi

	tc-is-cross-compiler && myeconfargs+=(
		--with-cross-build="${WORKDIR}"/host
	)

	# Work around cross-endian testing failures with LTO, bug #757681
	if tc-is-cross-compiler && tc-is-lto ; then
		myeconfargs+=( --disable-strict )
	fi

	# ICU tries to use clang by default
	tc-export CC CXX

	# Make sure we configure with the same shell as we run icu-config
	# with, or ECHO_N, ECHO_T and ECHO_C will be wrongly defined
	export CONFIG_SHELL="${EPREFIX}/bin/sh"
	# Probably have no /bin/sh in prefix-chain
	[[ -x ${CONFIG_SHELL} ]] || CONFIG_SHELL="${BASH}"

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use doc; then
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die

		HTML_DOCS+=( "${BUILD_DIR}"/doc/html/. )
	fi
}

multilib_src_test() {
	# INTLTEST_OPTS: intltest options
	#   -e: Exhaustive testing
	#   -l: Reporting of memory leaks
	#   -v: Increased verbosity
	# IOTEST_OPTS: iotest options
	#   -e: Exhaustive testing
	#   -v: Increased verbosity
	# CINTLTST_OPTS: cintltst options
	#   -e: Exhaustive testing
	#   -v: Increased verbosity
	emake check
}
