# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PATCH_VER="1.8"
UCLIBC_VER="1.1"
UCLIBC_GCC_VER="3.4.5"
HTB_VER="1.00.1"
HTB_GCC_VER="3.4.4"
D_VER="0.24"

inherit eutils toolchain

KEYWORDS="-* alpha amd64 arm ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"

# we need a proper glibc version for the Scrt1.o provided to the pie-ssp specs
# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/binutils-2.14.90.0.8-r1
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"

src_prepare() {
	toolchain_src_prepare

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		epatch "${FILESDIR}"/3.4.3/libffi-without-libgcj.patch
		#epatch ${FILESDIR}/3.4.3/libffi-nogcj-lib-path-fix.patch
	fi

	# Fix cross-compiling
	epatch "${FILESDIR}"/3.4.4/gcc-3.4.4-cross-compile.patch

	# Arch stuff
	case $(tc-arch) in
		amd64)
			if is_multilib ; then
				sed -i -e '/GLIBCXX_IS_NATIVE=/s:false:true:' libstdc++-v3/configure || die
			fi
			;;
	esac
}
