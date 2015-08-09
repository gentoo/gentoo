# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnatbuild

DESCRIPTION="GNAT Ada Compiler - gcc version"
HOMEPAGE="http://gcc.gnu.org/"
LICENSE="GMGPL"

IUSE="doc lto" # doc and lto from gnatbuild.eclass

# SLOT is set in gnatbuild.eclass, depends only on PV (basically SLOT=GCCBRANCH)
# so the URI's are static.
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-core-${PV}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-ada-${PV}.tar.bz2
	amd64? ( http://dev.gentoo.org/~george/src/gnatboot-${SLOT}-amd64.tar.bz2 )
	x86?   ( http://dev.gentoo.org/~george/src/gnatboot-${SLOT}-i686.tar.bz2 )
	ppc?   ( http://dev.gentoo.org/~george/src/gnatboot-4.1-ppc.tar.bz2 )"
#	sparc? ( mirror://gentoo/gnatboot-${BOOT_SLOT}-sparc.tar.bz2 )

KEYWORDS="amd64 ~ppc x86"

# starting with 4.3.0 gnat needs these libs
RDEPEND=">=dev-libs/mpfr-2.3.1
	>=dev-libs/gmp-4.2.2
	>=sys-libs/zlib-1.1.4
	>=sys-libs/ncurses-5.2-r2"

DEPEND="${RDEPEND}
	<sys-apps/texinfo-5.1
	>=sys-devel/bison-1.875
	>=sys-libs/glibc-2.8
	>=sys-devel/binutils-2.15.94"

#QA_EXECSTACK="${BINPATH:1}/gnatls ${BINPATH:1}/gnatbind ${BINPATH:1}/gnatmake
#	${LIBEXECPATH:1}/gnat1 ${LIBPATH:1}/adalib/libgnat-${SLOT}.so"

src_unpack() {
	gnatbuild_src_unpack

	# newly added zlib dir is processed by configure even with
	# --with-systtem-zlib passed, causing toruble on multilib
	rm -rf "${S}"/zlib

	#fixup some hardwired flags
	cd "${S}"/gcc/ada

	# universal gcc -> gnatgcc substitution occasionally produces lines too long
	# and then build halts on the style check.
	#
	# The sed in makegpr.adb is actually not for the line length but rather to
	# "undo" the fixing, Last3 is matching just that - the last three characters
	# of the compiler name.
	sed -i -e 's:(Last3 = "gnatgcc"):(Last3 = "gcc"):' makegpr.adb &&
	sed -i -e 's:and Nam is "gnatgcc":and Nam is "gcc":' osint.ads ||
		die	"reversing [gnat]gcc substitution in comments failed"
}

src_compile() {
	# looks like gnatlib_and_tools and gnatlib_shared have become part of
	# bootstrap
	gnatbuild_src_compile configure make-tools bootstrap
}
