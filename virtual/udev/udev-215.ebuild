# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Virtual to select between different udev daemon providers"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="systemd"

RDEPEND="
	!systemd? ( || ( >=sys-fs/eudev-1.3 >=sys-fs/udev-208-r1 ) )
	systemd? ( >=sys-apps/systemd-208:0 )"
