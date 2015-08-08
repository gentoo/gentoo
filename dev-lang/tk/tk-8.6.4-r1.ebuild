# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils multilib multilib-minimal prefix toolchain-funcs versionator virtualx

MY_P="${PN}${PV/_beta/b}"

DESCRIPTION="Tk Widget Set"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="mirror://sourceforge/tcl/${MY_P}-src.tar.gz"

LICENSE="tcltk"
SLOT="0/8.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug +threads truetype aqua xscreensaver"

RDEPEND="
	!aqua? (
		>=media-libs/fontconfig-2.10.92[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]
		truetype? ( >=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}] )
		xscreensaver? ( >=x11-libs/libXScrnSaver-1.2.2-r1[${MULTILIB_USEDEP}] )
	)
	~dev-lang/tcl-${PV}:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	!aqua? ( >=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}] )"

# Not bumped to 8.6
#RESTRICT=test

SPARENT="${WORKDIR}/${MY_P}"
S="${SPARENT}"/unix

src_prepare() {
	find \
		"${SPARENT}"/compat/* \
		-delete || die

	epatch \
		"${FILESDIR}"/${PN}-8.5.11-fedora-xft.patch \
		"${FILESDIR}"/${PN}-8.5.13-multilib.patch

	epatch "${FILESDIR}"/${PN}-8.4.15-aqua.patch
	eprefixify Makefile.in

	# Bug 125971
	epatch "${FILESDIR}"/${PN}-8.5.14-conf.patch

	# Make sure we use the right pkg-config, and link against fontconfig
	# (since the code base uses Fc* functions).
	sed \
		-e 's/FT_New_Face/XftFontOpen/g' \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		-e 's:xft freetype2:xft freetype2 fontconfig:' \
		-i configure.in || die
	rm -f configure || die

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
	local mylibdir=$(get_libdir)

	econf \
		--with-tcl="${EPREFIX}/usr/${mylibdir}" \
		$(use_enable threads) \
		$(use_enable aqua) \
		$(use_enable truetype xft) \
		$(use_enable xscreensaver xss) \
		$(use_enable debug symbols)
}

multilib_src_test() {
	Xemake test
}

multilib_src_install() {
	#short version number
	local v1=$(get_version_component_range 1-2)
	local mylibdir=$(get_libdir)

	S= default

	# normalize $S path, bug #280766 (pkgcore)
	local nS="$(cd "${S}"; pwd)"

	# fix the tkConfig.sh to eliminate refs to the build directory
	# and drop unnecessary -L inclusion to default system libdir

	sed \
		-e "/^TK_BUILD_LIB_SPEC=/s:-L${S}-\w*\.\w* ::g" \
		-e "/^TK_LIB_SPEC=/s:-L${EPREFIX}/usr/${mylibdir} *::g" \
		-e "/^TK_SRC_DIR=/s:${SPARENT}:${EPREFIX}/usr/${mylibdir}/tk${v1}/include:g" \
		-e "/^TK_BUILD_STUB_LIB_SPEC=/s:-L${S}-\w*\.\w* *::g" \
		-e "/^TK_STUB_LIB_SPEC=/s:-L${EPREFIX}/usr/${mylibdir} *::g" \
		-e "/^TK_BUILD_STUB_LIB_PATH=/s:${S}-\w*\.\w*:${EPREFIX}/usr/${mylibdir}:g" \
		-e "/^TK_LIB_FILE=/s:'libtk${v1}..TK_DBGX..so':\"libk${v1}\$\{TK_DBGX\}.so\":g" \
		-i "${ED}"/usr/${mylibdir}/tkConfig.sh || die
	if use prefix && [[ ${CHOST} != *-darwin* && ${CHOST} != *-mint* ]] ; then
		sed \
			-e "/^TK_CC_SEARCH_FLAGS=/s|'$|:${EPREFIX}/usr/${mylibdir}'|g" \
			-e "/^TK_LD_SEARCH_FLAGS=/s|'$|:${EPREFIX}/usr/${mylibdir}'|" \
			-i "${ED}"/usr/${mylibdir}/tkConfig.sh || die
	fi

	# install private headers
	insinto /usr/${mylibdir}/tk${v1}/include/unix
	doins "${S}"/*.h
	insinto /usr/${mylibdir}/tk${v1}/include/generic
	doins "${SPARENT}"/generic/*.h
	rm -f "${ED}"/usr/${mylibdir}/tk${v1}/include/generic/{tk,tkDecls,tkPlatDecls}.h || die

	# install symlink for libraries
	dosym libtk${v1}$(get_libname) /usr/${mylibdir}/libtk$(get_libname)
	dosym libtkstub${v1}.a /usr/${mylibdir}/libtkstub.a

	if multilib_is_native_abi; then
		dosym wish${v1} /usr/bin/wish
		dodoc "${SPARENT}"/{ChangeLog*,README,changes}
	fi
}
