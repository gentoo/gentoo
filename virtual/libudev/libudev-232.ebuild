# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib-build

DESCRIPTION="Virtual for libudev providers"
SLOT="0/1"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86"
IUSE="static-libs systemd"
REQUIRED_USE="systemd? ( !static-libs )"

RDEPEND="
	!systemd? (
		static-libs? (
			>=sys-fs/eudev-1.3:0/0[${MULTILIB_USEDEP},static-libs(-)]
		)
		!static-libs? ( || (
			>=sys-fs/eudev-1.3:0/0[${MULTILIB_USEDEP}]
			>=sys-fs/udev-232:0/0[${MULTILIB_USEDEP}]
		) )
	)
	systemd? ( >=sys-apps/systemd-212-r5:0/2[${MULTILIB_USEDEP}] )
"
