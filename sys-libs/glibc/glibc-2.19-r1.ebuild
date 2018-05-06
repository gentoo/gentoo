# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-glibc

DESCRIPTION="GNU libc6 (also called glibc2) C library"
HOMEPAGE="https://www.gnu.org/software/libc/libc.html"

LICENSE="LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
RESTRICT="strip" # strip ourself #46186
EMULTILIB_PKG="true"

# Configuration variables
RELEASE_VER=""
case ${PV} in
9999*)
	EGIT_REPO_URIS="git://sourceware.org/git/glibc.git"
	EGIT_SOURCEDIRS="${S}"
	inherit git-2
	;;
*)
	RELEASE_VER=${PV}
	;;
esac
GCC_BOOTSTRAP_VER="4.7.3-r1"
PATCH_VER="3"                                  # Gentoo patchset
NPTL_KERN_VER=${NPTL_KERN_VER:-"2.6.16"}       # min kernel version nptl requires

IUSE="debug gd hardened multilib nscd selinux systemtap profile suid vanilla headers-only"

# Here's how the cross-compile logic breaks down ...
#  CTARGET - machine that will target the binaries
#  CHOST   - machine that will host the binaries
#  CBUILD  - machine that will build the binaries
# If CTARGET != CHOST, it means you want a libc for cross-compiling.
# If CHOST != CBUILD, it means you want to cross-compile the libc.
#  CBUILD = CHOST = CTARGET    - native build/install
#  CBUILD != (CHOST = CTARGET) - cross-compile a native build
#  (CBUILD = CHOST) != CTARGET - libc for cross-compiler
#  CBUILD != CHOST != CTARGET  - cross-compile a libc for a cross-compiler
# For install paths:
#  CHOST = CTARGET  - install into /
#  CHOST != CTARGET - install into /usr/CTARGET/

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

[[ ${CTARGET} == hppa* ]] && NPTL_KERN_VER=${NPTL_KERN_VER/2.6.16/2.6.20}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# Why SLOT 2.2 you ask yourself while sippin your tea ?
# Everyone knows 2.2 > 0, duh.
SLOT="2.2"

# General: We need a new-enough binutils/gcc to match upstream baseline.
# arch: we need to make sure our binutils/gcc supports TLS.
DEPEND=">=app-misc/pax-utils-0.1.10
	!<sys-apps/sandbox-1.6
	!<sys-apps/portage-2.1.2
	selinux? ( sys-libs/libselinux )"
RDEPEND="!sys-kernel/ps3-sources
	selinux? ( sys-libs/libselinux )
	!sys-libs/nss-db"

if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND+=" !headers-only? (
		>=${CATEGORY}/binutils-2.20
		>=${CATEGORY}/gcc-4.3
	)"
	[[ ${CATEGORY} == *-linux* ]] && DEPEND+=" ${CATEGORY}/linux-headers"
else
	DEPEND+="
		>=sys-devel/binutils-2.20
		>=sys-devel/gcc-4.3
		virtual/os-headers
		!vanilla? ( >=sys-libs/timezone-data-2012c )"
	RDEPEND+="
		vanilla? ( !sys-libs/timezone-data )
		!vanilla? ( sys-libs/timezone-data )"
fi

upstream_uris() {
	echo mirror://gnu/glibc/$1 ftp://sourceware.org/pub/glibc/{releases,snapshots}/$1 mirror://gentoo/$1
}
gentoo_uris() {
	local devspace="HTTP~vapier/dist/URI HTTP~azarah/glibc/URI"
	devspace=${devspace//HTTP/https://dev.gentoo.org/}
	echo mirror://gentoo/$1 ${devspace//URI/$1}
}
SRC_URI=$(
	[[ -z ${EGIT_REPO_URIS} ]] && upstream_uris ${P}.tar.xz
	[[ -n ${PATCH_VER}      ]] && gentoo_uris ${P}-patches-${PATCH_VER}.tar.bz2
)
SRC_URI+=" ${GCC_BOOTSTRAP_VER:+multilib? ( $(gentoo_uris gcc-${GCC_BOOTSTRAP_VER}-multilib-bootstrap.tar.bz2) )}"

src_unpack() {
	[[ -n ${GCC_BOOTSTRAP_VER} ]] && use multilib && unpack gcc-${GCC_BOOTSTRAP_VER}-multilib-bootstrap.tar.bz2
	toolchain-glibc_src_unpack

	cd "${S}"

	epatch "${FILESDIR}"/2.19/${PN}-2.19-ia64-gcc-4.8-reloc-hack.patch #503838

	if use hardened ; then
		einfo "Patching to get working PIE binaries on PIE (hardened) platforms"
		tc-enables-pie && epatch "${FILESDIR}"/2.17/glibc-2.17-hardened-pie.patch
		epatch "${FILESDIR}"/2.19/glibc-2.19-hardened-configure-picdefault.patch
		epatch "${FILESDIR}"/2.18/glibc-2.18-hardened-inittls-nosysenter.patch

		einfo "Installing Hardened Gentoo SSP and FORTIFY_SOURCE handler"
		cp -f "${FILESDIR}"/2.18/glibc-2.18-gentoo-stack_chk_fail.c \
			debug/stack_chk_fail.c || die
		cp -f "${FILESDIR}"/2.18/glibc-2.18-gentoo-chk_fail.c \
			debug/chk_fail.c || die

		if use debug ; then
			# When using Hardened Gentoo stack handler, have smashes dump core for
			# analysis - debug only, as core could be an information leak
			# (paranoia).
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCFLAGS-stack_chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile \
				|| die "Failed to modify debug/Makefile for debug stack handler"
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCFLAGS-chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile \
				|| die "Failed to modify debug/Makefile for debug fortify handler"
		fi

		# Build nscd with ssp-all
		sed -i \
			-e 's:-fstack-protector$:-fstack-protector-all:' \
			nscd/Makefile \
			|| die "Failed to ensure nscd builds with ssp-all"
	fi
}

pkg_preinst() {
	toolchain-glibc_pkg_preinst

	if [[ ${CTARGET} == arm* ]] ; then
		# Backwards compat support for renaming hardfp ldsos #417287
		local oldso='/lib/ld-linux.so.3'
		local nldso='/lib/ld-linux-armhf.so.3'
		if [[ -e ${D}${nldso} ]] ; then
			if scanelf -qRyi "${ROOT}$(alt_prefix)"/*bin/ | grep -s "^${oldso}" ; then
				ewarn "Symlinking old ldso (${oldso}) to new ldso (${nldso})."
				ewarn "Please rebuild all packages using this old ldso as compat"
				ewarn "support will be dropped in the future."
				ln -s "${nldso##*/}" "${D}$(alt_prefix)${oldso}"
			fi
		fi
	fi
}
