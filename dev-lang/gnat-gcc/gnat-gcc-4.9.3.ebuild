# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PATCH_VER="1.5"
PIE_VER="0.6.4"
SPECS_VER="0.2.0"
SPECS_GCC_VER="4.4.3"
PIE_GLIBC_STABLE="amd64 x86 mips ppc ppc64 arm"
SSP_STABLE="amd64 x86 mips ppc ppc64 arm"

inherit gnatbuild-r1

DESCRIPTION="GNAT Ada Compiler - gcc version"
HOMEPAGE="https://gcc.gnu.org/"
LICENSE="GMGPL"

IUSE="acats doc hardened"

BOOT_SLOT="4.9"

# SLOT is set in gnatbuild-r1.eclass, depends only on PV (basically SLOT=GCCBRANCH)
# so the URI's are static.
KEYWORDS="~amd64 ~arm ~x86"

# arm is armv7-hardfloat, no neon:
#  (--with-arch=armv7-a --with-mode=thumb --with-float=hard --with-fpu=vfpv3-d16)
SRC_URI="mirror://gnu/gcc/gcc-${PV}/gcc-${PV}.tar.bz2
	mirror://gentoo/gcc-${PV}-patches-${PATCH_VER}.tar.bz2
	mirror://gentoo/gcc-${PV}-piepatches-v${PIE_VER}.tar.bz2
	hardened? ( mirror://gentoo/gcc-${SPECS_GCC_VER}-specs-${SPECS_VER}.tar.bz2 )
	amd64? ( http://dev.gentoo.org/~nerdboy/files/gnatboot-${BOOT_SLOT}-amd64.tar.xz )
	arm? ( http://dev.gentoo.org/~nerdboy/files/gnatboot-${BOOT_SLOT}-arm.tar.xz )
	x86? ( http://dev.gentoo.org/~nerdboy/files/gnatboot-${BOOT_SLOT}-i686.tar.xz )"

# starting with 4.3.0 gnat needs these libs
RDEPEND=">=dev-libs/mpfr-3.1.2
	>=dev-libs/gmp-5.1.3
	>=dev-libs/mpc-1.0.1
	>=sys-libs/zlib-1.2
	>=sys-libs/ncurses-5.7:0"

DEPEND="${RDEPEND}
	doc? ( >=sys-apps/texinfo-5 )"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} >=sys-libs/glibc-2.12"
fi

src_prepare() {
	# See if we can enable boehm-gc for Ada
	#epatch "${FILESDIR}"/${PN}-4.9.3-enable-boehm-gc-for-Ada.patch

	#fixup some hardwired flags
	pushd "${S}"/gcc/ada > /dev/null

	# universal gcc -> gnatgcc substitution occasionally produces lines too long
	# and then build halts on the style check.
	#
	sed -i -e 's:gnatgcc:gcc:' osint.ads switch.ads ||
		die	"reversing [gnat]gcc substitution in comments failed"

	popd > /dev/null

	# gcc pretty much ignores --with-system-zlib. At least it still descends
	# into zlib and does configure and build there (gcc bug@7125?). For whatever
	# reason this conflicts with multilib in gcc-4.4..
	sed -i -e "s:libgui zlib:libgui:" "${S}"/configure
}

src_compile() {
	# looks like gnatlib_and_tools and gnatlib_shared have become part of
	# bootstrap
	gnatbuild-r1_src_compile configure make-tools bootstrap
}

src_install() {
	gnatbuild-r1_src_install

	if use acats ; then
		insinto "${LIBPATH}"/acats
		doins -r "${S}"/gcc/testsuite/ada/acats/*
	fi
}
