# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for the internet super-server daemon"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	|| (
		sys-apps/xinetd
		sys-apps/netkit-base
		sys-apps/ucspi-tcp
		net-misc/ipsvd
		net-misc/inetutils[inetd]
	)
"
