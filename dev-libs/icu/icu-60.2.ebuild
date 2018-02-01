# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs autotools multilib-minimal

DESCRIPTION="International Components for Unicode"
HOMEPAGE="http://www.icu-project.org/"
SRC_URI="http://download.icu-project.org/files/icu4c/${PV/_/}/icu4c-${PV//./_}-src.tgz"

LICENSE="BSD"

SLOT="0/${PV}"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="debug doc examples static-libs"

DEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
	)
"

S="${WORKDIR}/${PN}/source"

MULTILIB_CHOST_TOOLS=(
	/usr/bin/icu-config
)

PATCHES=(
	"${FILESDIR}/${PN}-58.1-remove-bashisms.patch"
	"${FILESDIR}/${PN}-58.2-darwin.patch"
)

pkg_pretend() {
	if tc-is-gcc ; then
		if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 9 \
			|| $(gcc-major-version) -lt 4 ]] ; then
				die "You need at least sys-devel/gcc-4.9"
		fi
	fi
}

src_prepare() {
	# apply patches
	default

	local variable

	# Disable renaming as it is stupid thing to do
	sed -i \
		-e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" \
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
	# Use C++14
	append-cxxflags -std=c++14

	if tc-is-gcc ; then
		if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 9 \
			|| $(gcc-major-version) -lt 4 ]] ; then
				die "You need at least sys-devel/gcc-4.9"
		fi
	fi

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
		--disable-layoutex
		$(use_enable debug)
		$(use_enable static-libs static)
	)

	multilib_is_native_abi && myeconfargs+=(
		$(use_enable examples samples)
	)
	tc-is-cross-compiler && myeconfargs+=(
		--with-cross-build="${WORKDIR}"/host
	)

	# icu tries to use clang by default
	tc-export CC CXX

	# make sure we configure with the same shell as we run icu-config
	# with, or ECHO_N, ECHO_T and ECHO_C will be wrongly defined
	export CONFIG_SHELL=${EPREFIX}/bin/sh
	# probably have no /bin/sh in prefix-chain
	[[ -x ${CONFIG_SHELL} ]] || CONFIG_SHELL=${BASH}

	ECONF_SOURCE=${S} \
	econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use doc; then
		doxygen -u Doxyfile || die
		doxygen Doxyfile || die
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
	emake -j1 VERBOSE="1" check
}

multilib_src_install() {
	default

	if multilib_is_native_abi && use doc; then
		docinto html
		dodoc -r doc/html/*
	fi
}

multilib_src_install_all() {
	einstalldocs
	docinto html
	dodoc ../readme.html
}
