# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-build

DESCRIPTION="Virtual for libusb"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="udev"

# We force a recent libusb so that downstream consumers of virtual/libusb
# can depend on us directly (and not have to force >=libusb-1.0.19).
RDEPEND="
	>=dev-libs/libusb-1.0.19:1[udev(+)?,${MULTILIB_USEDEP}]
"
