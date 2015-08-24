# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic multilib

BINUTILS_PV="2.20.1"
NEWLIB_PV="1.20.0"
GCC_PV="4.4.3"
NACL_REVISION="${PV##*_p}"

DESCRIPTION="Native Client newlib-based toolchain (only for compiling IRT)"
HOMEPAGE="https://code.google.com/chrome/nativeclient/"
SRC_URI="mirror://gnu/binutils/binutils-${BINUTILS_PV}.tar.bz2
	ftp://sources.redhat.com/pub/newlib/newlib-${NEWLIB_PV}.tar.gz
	mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.bz2
	http://gsdview.appspot.com/nativeclient-archive2/x86_toolchain/r${NACL_REVISION}/nacltoolchain-buildscripts-r${NACL_REVISION}.tar.gz
	http://gsdview.appspot.com/nativeclient-archive2/x86_toolchain/r${NACL_REVISION}/naclbinutils-${BINUTILS_PV}-r${NACL_REVISION}.patch.bz2
	http://gsdview.appspot.com/nativeclient-archive2/x86_toolchain/r${NACL_REVISION}/naclnewlib-${NEWLIB_PV}-r${NACL_REVISION}.patch.bz2
	http://gsdview.appspot.com/nativeclient-archive2/x86_toolchain/r${NACL_REVISION}/naclgcc-${GCC_PV}-r${NACL_REVISION}.patch.bz2
"

LICENSE="BSD" # NaCl
LICENSE+=" || ( GPL-3 LGPL-3 )" # binutils
LICENSE+=" NEWLIB LIBGLOSS GPL-2" # newlib
LICENSE+=" GPL-3 LGPL-3 || ( GPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.2" # gcc

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Stripping with a non-NaCl strip breaks the toolchain, bug #386931.
# Tests are broken, bug #391761.
RESTRICT="strip test"

# Executable section checks do not make sense for newlib, bug #390383.
QA_EXECSTACK="usr/lib*/nacl-toolchain-newlib/*/lib*/*"

RDEPEND="
	>=dev-libs/gmp-5.0.2
	>=dev-libs/mpfr-3.0.1
	>=sys-libs/glibc-2.8
	>=sys-libs/zlib-1.1.4
"
DEPEND="${RDEPEND}
	app-arch/zip
	app-arch/unzip
	dev-libs/mpc
	dev-libs/cloog-ppl
	dev-libs/ppl
	>=media-libs/libart_lgpl-2.1
	>=sys-apps/texinfo-4.8
	>=sys-devel/binutils-2.15.94
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4
	sys-devel/gnuconfig
	sys-devel/m4
	>=sys-libs/ncurses-5.2-r2
	>=sys-apps/sed-4
	sys-devel/gettext
	virtual/libiconv
	virtual/yacc
"

S="${WORKDIR}"

pkg_setup() {
	# Unset variables known to break the build. This is a black-list
	# rather than white-list because it's not obvious how to come up
	# with a comprehensive white-list.
	# For more info see bug #413995.
	unset -v LANGUAGES || die
}

src_prepare() {
	mkdir SRC || die
	mv binutils-${BINUTILS_PV} SRC/binutils || die
	mv newlib-${NEWLIB_PV} SRC/newlib || die
	mv gcc-${GCC_PV} SRC/gcc || die
	cd SRC || die
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch "${S}"

	# Parallel build failure, bug #437048.
	epatch "${FILESDIR}/gcc-parallel-build-r0.patch"

	cd "${S}/SRC/binutils" || die
	epatch "${FILESDIR}/binutils-texinfo-r0.patch"

	cd "${S}/SRC/gcc" || die
	epatch "${FILESDIR}/gcc-texinfo-r0.patch"
}

src_compile() {
	strip-flags # See bug #390589.
	emake PREFIX="${PWD}/${PN}" CANNED_REVISION="yes" build-with-newlib
}

src_install() {
	local TOOLCHAIN_HOME="/usr/$(get_libdir)"
	dodir "${TOOLCHAIN_HOME}"
	mv "${WORKDIR}/${PN}" "${ED}/${TOOLCHAIN_HOME}" || die
}
