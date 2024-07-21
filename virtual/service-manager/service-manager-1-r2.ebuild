# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for various service managers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	prefix-guest? ( >=sys-apps/baselayout-prefix-2.2 )
	!prefix-guest? (
		|| (
			|| (
				sys-apps/openrc
				sys-apps/openrc-navi
			)
			kernel_linux? (
				|| (
					sys-apps/s6-rc
					sys-apps/systemd
					sys-process/runit
					virtual/daemontools
				)
			)
		)
	)"
