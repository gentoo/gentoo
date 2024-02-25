# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Please bump with dev-lang/tk!

inherit autotools flag-o-matic multilib-minimal multilib toolchain-funcs

MY_P="${PN}${PV}"

DESCRIPTION="Tool Command Language"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="mirror://sourceforge/tcl/${PN}-core${PV}-src.tar.gz"

LICENSE="tcltk"
SLOT="0/8.6"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug +threads"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

SPARENT="${WORKDIR}/${MY_P}"
S="${SPARENT}"/unix

PATCHES=(
	"${FILESDIR}"/${PN}-8.6.10-multilib.patch
	"${FILESDIR}"/${PN}-8.6.8-conf.patch # Bug 125971
	"${FILESDIR}"/${PN}-8.6.9-include-spec.patch # Bug 731120
	"${FILESDIR}"/${PN}-8.6.13-tclConfig-TCL_PACKAGE_PATH-braces.patch # Bug 892029
)

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 opendir64 rewinddir64 closedir64 # used to test for Large File Support
)

src_prepare() {
	find \
		"${SPARENT}"/compat/* \
		"${SPARENT}"/doc/try.n \
		-delete || die

	pushd "${SPARENT}" &>/dev/null || die
	default
	popd &>/dev/null || die

	# httpold tests require netowk
	rm ../tests/httpold.test \
		../tests/env.test \
		../tests/http.test \
		|| die

	# workaround stack check issues, bug #280934
	use hppa && append-cflags "-DTCL_NO_STACK_CHECK=1"

	tc-export CC

	sed \
		-e '/chmod/s:555:755:g' \
		-i Makefile.in || die

	sed \
		-e 's:-O[2s]\?::g' \
		-i tcl.m4 || die

	mv configure.{in,ac} || die

	eautoconf

	multilib_copy_sources
}

multilib_src_configure() {
	# We went ahead and deleted the whole compat/ subdir which means
	# the configure tests to detect broken versions need to pass (else
	# we'll fail to build).  This comes up when cross-compiling, but
	# might as well get a minor configure speed up normally.
	export ac_cv_func_memcmp_working="yes"
	export tcl_cv_str{str,toul,tod}_unbroken="ok"
	export tcl_cv_strtod_buggy="no"

	econf \
		$(use_enable threads) \
		$(use_enable debug symbols)
}

multilib_src_install() {
	#short version number
	local v1=$(ver_cut 1-2)
	local mylibdir=$(get_libdir)

	S= default
	# fix the tclConfig.sh to eliminate refs to the build directory
	# and drop unnecessary -L inclusion to default system libdir

	sed \
		-e "/^TCL_BUILD_LIB_SPEC=/s:-L$(pwd) *::g" \
		-e "/^TCL_LIB_SPEC=/s:-L${EPREFIX}/usr/${mylibdir} *::g" \
		-e "/^TCL_SRC_DIR=/s:${SPARENT}:${EPREFIX}/usr/${mylibdir}/tcl${v1}/include:g" \
		-e "/^TCL_BUILD_STUB_LIB_SPEC=/s:-L$(pwd) *::g" \
		-e "/^TCL_STUB_LIB_SPEC=/s:-L${EPREFIX}/usr/${mylibdir} *::g" \
		-e "/^TCL_BUILD_STUB_LIB_PATH=/s:$(pwd):${EPREFIX}/usr/${mylibdir}:g" \
		-e "/^TCL_LIBW_FILE=/s:'libtcl${v1}..TCL_DBGX..so':\"libtcl${v1}\$\{TCL_DBGX\}.so\":g" \
		-i "${ED}"/usr/${mylibdir}/tclConfig.sh || die
	if use prefix && [[ ${CHOST} != *-darwin* ]] ; then
		sed \
			-e "/^TCL_CC_SEARCH_FLAGS=/s|'$|:${EPREFIX}/usr/${mylibdir}'|g" \
			-e "/^TCL_LD_SEARCH_FLAGS=/s|'$|:${EPREFIX}/usr/${mylibdir}'|" \
			-i "${ED}"/usr/${mylibdir}/tclConfig.sh || die
	fi

	# install private headers
	insinto /usr/${mylibdir}/tcl${v1}/include/unix
	doins *.h
	insinto /usr/${mylibdir}/tcl${v1}/include/generic
	doins "${SPARENT}"/generic/*.h
	rm -f "${ED}"/usr/${mylibdir}/tcl${v1}/include/generic/{tcl,tclDecls,tclPlatDecls}.h || die

	# install symlink for libraries
	dosym libtcl${v1}$(get_libname) /usr/${mylibdir}/libtcl$(get_libname)
	dosym libtclstub${v1}.a /usr/${mylibdir}/libtclstub.a

	if multilib_is_native_abi; then
		dosym tclsh${v1} /usr/bin/tclsh
		dodoc "${SPARENT}"/{ChangeLog*,README.md,changes}
	fi
}
