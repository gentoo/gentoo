# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnatbuild

DESCRIPTION="GNAT Ada Compiler - gcc version"
HOMEPAGE="https://gcc.gnu.org/"
LICENSE="GMGPL"

IUSE="doc"

BOOT_SLOT="4.4"

# SLOT is set in gnatbuild.eclass, depends only on PV (basically SLOT=GCCBRANCH)
# so the URI's are static.
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-core-${PV}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-ada-${PV}.tar.bz2
	amd64? ( https://dev.gentoo.org/~george/src/gnatboot-${BOOT_SLOT}-amd64.tar.bz2 )
	sparc? ( https://dev.gentoo.org/~george/src/gnatboot-${BOOT_SLOT}-sparc.tar.bz2 )
	x86?   ( https://dev.gentoo.org/~george/src/gnatboot-${BOOT_SLOT}-i686.tar.bz2 )"
#	ppc?   ( mirror://gentoo/gnatboot-${BOOT_SLOT}-ppc.tar.bz2 )

KEYWORDS="amd64 x86"

# starting with 4.3.0 gnat needs these libs
RDEPEND=">=dev-libs/mpfr-3.0.1
	>=dev-libs/gmp-5.0
	>=sys-libs/zlib-1.2
	>=sys-libs/ncurses-5.7"

DEPEND="${RDEPEND}
	doc? ( sys-apps/texinfo )
	>=sys-devel/bison-1.875
	>=sys-libs/glibc-2.8
	>=sys-devel/binutils-2.20"

#QA_EXECSTACK="${BINPATH:1}/gnatls ${BINPATH:1}/gnatbind ${BINPATH:1}/gnatmake
#	${LIBEXECPATH:1}/gnat1 ${LIBPATH:1}/adalib/libgnat-${SLOT}.so"

src_unpack() {
	gnatbuild_src_unpack

	#fixup some hardwired flags
	cd "${S}"/gcc/ada

	# universal gcc -> gnatgcc substitution occasionally produces lines too long
	# and then build halts on the style check.
	#
	sed -i -e 's:gnatgcc:gcc:' osint.ads switch.ads ||
		die	"reversing [gnat]gcc substitution in comments failed"

	# gcc pretty much ignores --with-system-zlib. At least it still descends
	# into zlib and does configure and build there (gcc bug@7125?). For whatever
	# reason this conflicts with multilib in gcc-4.4..
	sed -i -e "s:libgui zlib:libgui:" "${S}"/configure
}

src_compile() {
	# work-around for downgrading texinfo.  See bug #483192
	if use doc ; then
		if has_version ">=sys-apps/texinfo-5.1" ; then
			ewarn "Disabling info docs.  Please downgrade texinfo to less than 5.x or"
			ewarn "use ${PN}-4.6 instead (as upstream has only patched 4.6 and higher)."
			epatch "${FILESDIR}"/${P}-tex-version-workaround.patch
		fi
	else
		elog "Disabling info docs."
		epatch "${FILESDIR}"/${P}-tex-version-workaround.patch
	fi

	# looks like gnatlib_and_tools and gnatlib_shared have become part of
	# bootstrap
	gnatbuild_src_compile configure make-tools bootstrap
}
