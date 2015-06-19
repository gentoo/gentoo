# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/tcl/tcl-8.5.15-r1.ebuild,v 1.17 2015/03/16 23:07:57 vapier Exp $

EAPI=5

inherit autotools eutils flag-o-matic multilib toolchain-funcs versionator multilib-minimal

MY_P="${PN}${PV/_beta/b}"

DESCRIPTION="Tool Command Language"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="mirror://sourceforge/tcl/${MY_P}-src.tar.gz"

LICENSE="tcltk"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="debug threads"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

SPARENT="${WORKDIR}/${MY_P}"
S="${SPARENT}"/unix

src_prepare() {
	epatch "${FILESDIR}"/${PN}-8.5.13-multilib.patch

	# Bug 125971
	epatch "${FILESDIR}"/${PN}-8.5.14-conf.patch

	# Bug 354067
	epatch "${FILESDIR}"/${PN}-8.5.9-gentoo-fbsd.patch

	# workaround stack check issues, bug #280934
	use hppa && append-cflags "-DTCL_NO_STACK_CHECK=1"

	tc-export CC

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
	local v1=$(get_version_component_range 1-2)
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
		-e "/^TCL_LIB_FILE=/s:'libtcl${v1}..TCL_DBGX..so':\"libtcl${v1}\$\{TCL_DBGX\}.so\":g" \
		-i "${ED}"/usr/${mylibdir}/tclConfig.sh || die
	if use prefix && [[ ${CHOST} != *-darwin* && ${CHOST} != *-mint* ]] ; then
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
		dodoc "${SPARENT}"/{ChangeLog*,README,changes}
	fi
}

pkg_postinst() {
	for version in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least 8.5 ${version}; then
			echo
			ewarn "You're upgrading from <${P}, you must recompile the other"
			ewarn "packages on your system that link with tcl after the upgrade"
			ewarn "completes. To perform this action, please run revdep-rebuild"
			ewarn "in package app-portage/gentoolkit."
			ewarn "If you have dev-lang/tk and dev-tcltk/tclx installed you should"
			ewarn "upgrade them before this recompilation, too,"
			echo
		fi
	done
}
