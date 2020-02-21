# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for various service managers"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="kernel_linux"

RDEPEND="
	prefix-guest? ( >=sys-apps/baselayout-prefix-2.2 )
	!prefix-guest? (
		|| (
		sys-apps/openrc
		kernel_linux? ( || (
			sys-apps/systemd
			sys-process/runit
			virtual/daemontools
	) ) ) )"
