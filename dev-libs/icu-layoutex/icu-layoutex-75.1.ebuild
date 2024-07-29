# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with dev-libs/icu
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/icu.asc
inherit autotools flag-o-matic multilib-minimal toolchain-funcs verify-sig

MY_PV=${PV/_rc/-rc}
MY_PV=${MY_PV//./_}

DESCRIPTION="External layout part of International Components for Unicode"
HOMEPAGE="https://icu.unicode.org/"
SRC_URI="https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-src.tgz"
SRC_URI+=" verify-sig? ( https://github.com/unicode-org/icu/releases/download/release-${MY_PV/_/-}/icu4c-${MY_PV/-rc/rc}-src.tgz.asc )"
S="${WORKDIR}"/${PN/-layoutex}/source

LICENSE="BSD"
SLOT="0/${PV%.*}"
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi
IUSE="debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	~dev-libs/icu-${PV}[${MULTILIB_USEDEP}]
	dev-libs/icu-le-hb[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( >=sec-keys/openpgp-keys-icu-20221020 )
"

PATCHES=( "${FILESDIR}/${PN}-65.1-remove-bashisms.patch" )

src_prepare() {
	default

	# Disable renaming as it assumes stable ABI and that consumers
	# won't use unofficial APIs. We need this despite the configure argument.
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
		common/unicode/uconfig.h || die

	# Fix linking of icudata
	sed -i \
		-e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" \
		config/mh-linux || die

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

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# https://unicode-org.atlassian.net/browse/ICU-22001
	filter-lto

	local myeconfargs=(
		--disable-renaming
		# We want a minimal build as this is just for layoutex
		# so we disable as much as possible
		--disable-samples
		--disable-extras
		--disable-icuio

		# This is icu-layoutex, so..
		--enable-layoutex

		$(use_enable debug)
		$(use_enable static-libs static)

		# Need tools for tests, otherwise get this in configure:
		# "## Note: you have disabled ICU's tools. This ICU cannot build its own data or tests.
		# ## Expect build failures in the 'data', 'test', and other directories."
		# ... although layoutex has no tests right now anyway, but let's keep this
		# for the future.
		$(use_enable test tools)
		$(use_enable test tests)
	)

	tc-is-cross-compiler && myeconfargs+=(
		--with-cross-build="${WORKDIR}"/host
	)

	# icu tries to use clang by default
	tc-export CC CXX

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
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
	emake -C layoutex VERBOSE="1" check
}

multilib_src_install() {
	pushd layoutex &>/dev/null || die
	default
	popd &>/dev/null || die
}
