# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for libudev providers"

SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs systemd"

RDEPEND="
	!systemd? ( || (
		>=sys-fs/udev-249:0/0[${MULTILIB_USEDEP},static-libs(-)?]
		>=sys-fs/eudev-3.2.9:0/0[${MULTILIB_USEDEP},static-libs(-)?]
	) )
	systemd? ( >=sys-apps/systemd-249:0/2[${MULTILIB_USEDEP},static-libs(-)?] )
"
