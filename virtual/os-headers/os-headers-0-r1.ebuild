# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for operating system headers"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# depend on SLOT 0 of linux-headers, because kernel-2.eclass
# sets a different SLOT for cross-building
RDEPEND="
	!prefix-guest? (
		|| (
			kernel_linux? ( sys-kernel/linux-headers:0 )
			kernel_Winnt? (
				elibc_mingw? ( dev-util/mingw64-runtime )
			)
			!prefix? ( sys-freebsd/freebsd-lib )
		)
	)
	prefix-guest? (
		!sys-kernel/linux-headers
		!sys-freebsd/freebsd-lib
	)"
