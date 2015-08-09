# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PATCH_VER="1.9"
UCLIBC_VER="1.0"
HTB_VER="1.00-r2"

inherit eutils toolchain

# ia64 - broken static handling; USE=static emerge busybox
KEYWORDS="~amd64 ~x86"

# NOTE: we SHOULD be using at least binutils 2.15.90.0.1 everywhere for proper
# .eh_frame ld optimisation and symbol visibility support, but it hasnt been
# well tested in gentoo on any arch other than amd64!!
RDEPEND=">=sys-devel/binutils-2.14.90.0.6-r1"
DEPEND="${RDEPEND}
	amd64? ( >=sys-devel/binutils-2.15.90.0.1.1-r1 )"

src_prepare() {
	toolchain_src_prepare

	if [[ -n ${UCLIBC_VER} ]] && [[ ${CTARGET} == *-uclibc* ]] ; then
		mv "${S}"/gcc-3.3.2/libstdc++-v3/config/os/uclibc "${S}"/libstdc++-v3/config/os/ || die
		mv "${S}"/gcc-3.3.2/libstdc++-v3/config/locale/uclibc "${S}"/libstdc++-v3/config/locale/ || die
	fi

	# Anything useful and objc will require libffi. Seriously. Lets just force
	# libffi to install with USE="objc", even though it normally only installs
	# if you attempt to build gcj.
	if use objc && ! use gcj ; then
		epatch "${FILESDIR}"/3.3.4/libffi-without-libgcj.patch
		#epatch "${FILESDIR}"/3.4.3/libffi-nogcj-lib-path-fix.patch
	fi
}
