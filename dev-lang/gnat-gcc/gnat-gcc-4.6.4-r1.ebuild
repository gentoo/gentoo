# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnatbuild

DESCRIPTION="GNAT Ada Compiler - gcc version"
HOMEPAGE="https://gcc.gnu.org/"
LICENSE="GMGPL"

IUSE="doc openmp"

BOOT_SLOT="4.4"

# SLOT is set in gnatbuild.eclass, depends only on PV (basically SLOT=GCCBRANCH)
# so the URI's are static.
SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-core-${PV}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${PV}/gcc-ada-${PV}.tar.bz2
	amd64? ( https://dev.gentoo.org/~george/src/gnatboot-${BOOT_SLOT}-amd64.tar.bz2 )
	sparc? ( https://dev.gentoo.org/~george/src/gnatboot-${BOOT_SLOT}-sparc.tar.bz2 )
	x86?   ( https://dev.gentoo.org/~george/src/gnatboot-${BOOT_SLOT}-i686.tar.bz2 )
	arm?   ( https://dev.gentoo.org/~nerdboy/files/gnatboot-${BOOT_SLOT}-arm.tar.xz )"
#	ppc?   ( mirror://gentoo/gnatboot-${BOOT_SLOT}-ppc.tar.bz2 )

KEYWORDS="~amd64 ~arm ~sparc ~x86"

# starting with 4.3.0 gnat needs these libs
RDEPEND=">=dev-libs/mpfr-3.1.2
	>=dev-libs/gmp-5.1.3
	>=dev-libs/mpc-1.0.1
	>=sys-libs/zlib-1.2
	>=sys-libs/ncurses-5.7:0"

DEPEND="${RDEPEND}
	doc? ( >=sys-apps/texinfo-5 )"

src_unpack() {
	gnatbuild_src_unpack all
}

src_prepare() {
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

src_configure() {
	:
}

src_compile() {
	# looks like gnatlib_and_tools and gnatlib_shared have become part of
	# bootstrap
	gnatbuild_src_compile configure make-tools bootstrap
}

src_install() {
	gnatbuild_src_install all
}
