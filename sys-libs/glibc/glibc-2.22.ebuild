# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils versionator toolchain-funcs flag-o-matic gnuconfig multilib systemd unpacker multiprocessing

DESCRIPTION="GNU libc6 (also called glibc2) C library"
HOMEPAGE="https://www.gnu.org/software/libc/libc.html"

LICENSE="LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
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
PATCH_VER="7"                                  # Gentoo patchset
: ${NPTL_KERN_VER:="2.6.32"}                   # min kernel version nptl requires

IUSE="debug gd hardened multilib nscd selinux systemtap profile suid vanilla crosscompile_opts_headers-only"

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
	sys-apps/gentoo-functions
	selinux? ( sys-libs/libselinux )
	!sys-libs/nss-db"

if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND+=" !crosscompile_opts_headers-only? (
		>=${CATEGORY}/binutils-2.24
		>=${CATEGORY}/gcc-4.6
	)"
	[[ ${CATEGORY} == *-linux* ]] && DEPEND+=" ${CATEGORY}/linux-headers"
else
	DEPEND+="
		>=sys-devel/binutils-2.24
		>=sys-devel/gcc-4.6
		virtual/os-headers"
	RDEPEND+=" vanilla? ( !sys-libs/timezone-data )"
	PDEPEND+=" !vanilla? ( sys-libs/timezone-data )"
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

# eblit-include [--skip] <function> [version]
eblit-include() {
	local skipable=false
	[[ $1 == "--skip" ]] && skipable=true && shift
	[[ $1 == pkg_* ]] && skipable=true

	local e v func=$1 ver=$2
	[[ -z ${func} ]] && die "Usage: eblit-include <function> [version]"
	for v in ${ver:+-}${ver} -${PVR} -${PV} "" ; do
		e="${FILESDIR}/eblits/${func}${v}.eblit"
		if [[ -e ${e} ]] ; then
			source "${e}"
			return 0
		fi
	done
	${skipable} && return 0
	die "Could not locate requested eblit '${func}' in ${FILESDIR}/eblits/"
}

# eblit-run-maybe <function>
# run the specified function if it is defined
eblit-run-maybe() {
	[[ $(type -t "$@") == "function" ]] && "$@"
}

# eblit-run <function> [version]
# aka: src_unpack() { eblit-run src_unpack ; }
eblit-run() {
	eblit-include --skip common "${*:2}"
	eblit-include "$@"
	eblit-run-maybe eblit-$1-pre
	eblit-${PN}-$1
	eblit-run-maybe eblit-$1-post
}

src_unpack()    { eblit-run src_unpack    ; }
src_prepare()   { eblit-run src_prepare   ; }
src_configure() { eblit-run src_configure ; }
src_compile()   { eblit-run src_compile   ; }
src_test()      { eblit-run src_test      ; }
src_install()   { eblit-run src_install   ; }

# FILESDIR might not be available during binpkg install
for x in pretend setup {pre,post}inst ; do
	e="${FILESDIR}/eblits/pkg_${x}.eblit"
	if [[ -e ${e} ]] ; then
		. "${e}"
		eval "pkg_${x}() { eblit-run pkg_${x} ; }"
	fi
done

eblit-src_unpack-pre() {
	[[ -n ${GCC_BOOTSTRAP_VER} ]] && use multilib && unpack gcc-${GCC_BOOTSTRAP_VER}-multilib-bootstrap.tar.bz2
}

eblit-src_prepare-post() {
	cd "${S}"

	if use hardened ; then
		einfo "Patching to get working PIE binaries on PIE (hardened) platforms"
		gcc-specs-pie && epatch "${FILESDIR}"/2.17/glibc-2.17-hardened-pie.patch
		epatch "${FILESDIR}"/2.20/glibc-2.20-hardened-inittls-nosysenter.patch

		# We don't enable these for non-hardened as the output is very terse --
		# it only states that a crash happened.  The default upstream behavior
		# includes backtraces and symbols.
		einfo "Installing Hardened Gentoo SSP and FORTIFY_SOURCE handler"
		cp "${FILESDIR}"/2.20/glibc-2.20-gentoo-stack_chk_fail.c debug/stack_chk_fail.c || die
		cp "${FILESDIR}"/2.20/glibc-2.20-gentoo-chk_fail.c debug/chk_fail.c || die

		if use debug ; then
			# Allow SIGABRT to dump core on non-hardened systems, or when debug is requested.
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCPPFLAGS-stack_chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				-e '/^CFLAGS-backtrace.c/ iCPPFLAGS-chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile || die
		fi

		# Build various bits with ssp-all
		sed -i \
			-e 's:-fstack-protector$:-fstack-protector-all:' \
			*/Makefile || die
	fi

	case $(gcc-fullversion) in
	4.8.[0-3]|4.9.0)
		eerror "You need to switch to a newer compiler; gcc-4.8.[0-3] and gcc-4.9.0 miscompile"
		eerror "glibc.  See https://bugs.gentoo.org/547420 for details."
		die "need to switch compilers #547420"
		;;
	esac
}
