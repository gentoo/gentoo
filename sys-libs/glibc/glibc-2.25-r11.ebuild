# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-glibc

DESCRIPTION="GNU libc6 (also called glibc2) C library"
HOMEPAGE="https://www.gnu.org/software/libc/libc.html"

LICENSE="LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
EMULTILIB_PKG="true"

# Configuration variables
RELEASE_VER=""
case ${PV} in
9999*)
	EGIT_REPO_URIS="git://sourceware.org/git/glibc.git"
	inherit git-r3
	;;
*)
	RELEASE_VER=${PV}
	;;
esac
GCC_BOOTSTRAP_VER="4.7.3-r1"
# patches live at https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo/src/patchsets/glibc/
PATCH_VER="15"                                 # Gentoo patchset
: ${NPTL_KERN_VER:="2.6.32"}                   # min kernel version nptl requires

GLIBC_PATCH_EXCLUDE+=" 0005_all_sys-types.h-drop-sys-sysmacros.h-include.patch"

IUSE="audit caps debug gd hardened multilib nscd +rpc selinux systemtap profile suid vanilla headers-only"

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

# Note [Disable automatic stripping]
# Disabling automatic stripping for a few reasons:
# - portage's attempt to strip breaks non-native binaries at least on
#   arm: bug #697428
# - portage's attempt to strip libpthread.so.0 breaks gdb thread
#   enumeration: bug #697910. This is quite subtle:
#   * gdb uses glibc's libthread_db-1.0.so to enumerate threads.
#   * libthread_db-1.0.so needs access to libpthread.so.0 local symbols
#     via 'ps_pglobal_lookup' symbol defined in gdb.
#   * 'ps_pglobal_lookup' uses '.symtab' section table to resolve all
#     known symbols in 'libpthread.so.0'. Specifically 'nptl_version'
#     (unexported) is used to sanity check compatibility before enabling
#     debugging.
#     Also see https://sourceware.org/gdb/wiki/FAQ#GDB_does_not_see_any_threads_besides_the_one_in_which_crash_occurred.3B_or_SIGTRAP_kills_my_program_when_I_set_a_breakpoint
#   * normal 'strip' command trims '.symtab'
#   Thus our main goal here is to prevent 'libpthread.so.0' from
#   losing it's '.symtab' entries.
# As Gentoo's strip does not allow us to pass less aggressive stripping
# options and does not check the machine target we disable stripping
# entirely.
RESTRICT=strip

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

# Why SLOT 2.2 you ask yourself while sippin your tea ?
# Everyone knows 2.2 > 0, duh.
SLOT="2.2"

# General: We need a new-enough binutils/gcc to match upstream baseline.
# arch: we need to make sure our binutils/gcc supports TLS.
COMMON_DEPEND="
	nscd? ( selinux? (
		audit? ( sys-process/audit )
		caps? ( sys-libs/libcap )
	) )
	suid? ( caps? ( sys-libs/libcap ) )
	selinux? ( sys-libs/libselinux )
	systemtap? ( dev-util/systemtap )
"
DEPEND="${COMMON_DEPEND}
	>=app-misc/pax-utils-0.1.10
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/gentoo-functions"

if [[ ${CATEGORY} == cross-* ]] ; then
	DEPEND+=" !headers-only? (
		>=${CATEGORY}/binutils-2.24
		>=${CATEGORY}/gcc-4.7
	)"
	[[ ${CATEGORY} == *-linux* ]] && DEPEND+=" ${CATEGORY}/linux-headers"
else
	DEPEND+="
		>=sys-devel/binutils-2.24
		>=sys-devel/gcc-4.7
		virtual/os-headers"
	RDEPEND+=" vanilla? ( !sys-libs/timezone-data )"
	PDEPEND+=" !vanilla? ( sys-libs/timezone-data )"
fi

upstream_uris() {
	echo mirror://gnu/glibc/$1 ftp://sourceware.org/pub/glibc/{releases,snapshots}/$1 mirror://gentoo/$1
}
gentoo_uris() {
	local devspace="HTTP~vapier/dist/URI HTTP~dilfridge/distfiles/URI HTTP~tamiko/distfiles/URI HTTP~slyfox/distfiles/URI"
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
}

src_prepare() {
	toolchain-glibc_src_prepare

	cd "${S}"

	epatch "${FILESDIR}"/2.19/${PN}-2.19-ia64-gcc-4.8-reloc-hack.patch #503838

	if use hardened ; then
		# We don't enable these for non-hardened as the output is very terse --
		# it only states that a crash happened.  The default upstream behavior
		# includes backtraces and symbols.
		einfo "Installing Hardened Gentoo SSP and FORTIFY_SOURCE handler"
		cp "${FILESDIR}"/2.20/glibc-2.20-gentoo-stack_chk_fail.c debug/stack_chk_fail.c || die
		cp "${FILESDIR}"/2.25/glibc-2.25-gentoo-chk_fail.c debug/chk_fail.c || die

		if use debug ; then
			# Allow SIGABRT to dump core on non-hardened systems, or when debug is requested.
			sed -i \
				-e '/^CFLAGS-backtrace.c/ iCPPFLAGS-stack_chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				-e '/^CFLAGS-backtrace.c/ iCPPFLAGS-chk_fail.c = -DSSP_SMASH_DUMPS_CORE' \
				debug/Makefile || die
		fi
	fi

	case $(gcc-fullversion) in
	4.8.[0-3]|4.9.0)
		eerror "You need to switch to a newer compiler; gcc-4.8.[0-3] and gcc-4.9.0 miscompile"
		eerror "glibc.  See https://bugs.gentoo.org/547420 for details."
		die "need to switch compilers #547420"
		;;
	esac
}
