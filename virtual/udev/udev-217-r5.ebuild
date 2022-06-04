# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual to select between different udev daemon providers"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	|| (
		sys-apps/systemd-utils[udev]
		sys-fs/udev
		>=sys-fs/eudev-2.1.1
		>=sys-apps/systemd-217
	)
"
