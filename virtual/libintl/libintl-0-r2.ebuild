# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for the GNU Internationalization Library"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="elibc_glibc elibc_musl elibc_uclibc"

# - Don't put elibc_glibc? ( sys-libs/glibc ) to avoid circular deps between
# that and gcc. And don't force uClibc to dep on this.
RDEPEND="!elibc_glibc? ( !elibc_uclibc? ( !elibc_musl? ( dev-libs/libintl[${MULTILIB_USEDEP}] ) ) )"
