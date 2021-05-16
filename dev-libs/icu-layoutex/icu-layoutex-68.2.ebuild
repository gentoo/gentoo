# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="External layout part of International Components for Unicode"
HOMEPAGE="http://www.icu-project.org/"
SRC_URI="https://github.com/unicode-org/icu/releases/download/release-${PV//./-}/icu4c-${PV//./_}-src.tgz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="debug static-libs"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	~dev-libs/icu-${PV}[${MULTILIB_USEDEP}]
	dev-libs/icu-le-hb[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN/-layoutex}/source"

PATCHES=(
	"${FILESDIR}/${PN}-65.1-remove-bashisms.patch"
)

src_prepare() {
	# apply patches
	default

	# Disable renaming as it is stupid thing to do
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
	# Use C++14
	append-cxxflags -std=c++14

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
	local myeconfargs=(
		--disable-renaming
		--disable-samples
		--enable-layoutex
		$(use_enable debug)
		$(use_enable static-libs static)
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
	pushd layoutex &>/dev/null || die
	emake -j1 VERBOSE="1" check
	popd &>/dev/null || die
}

multilib_src_install() {
	pushd layoutex &>/dev/null || die
	default
	popd &>/dev/null || die
}
