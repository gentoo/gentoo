# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Preview a GRUB 2.x theme using KVM/QEMU"
HOMEPAGE="https://github.com/hartwork/grub2-theme-preview"
SRC_URI="https://github.com/hartwork/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="grub_platforms_efi-32 grub_platforms_efi-64 grub_platforms_pc"
REQUIRED_USE="|| ( grub_platforms_efi-32 grub_platforms_efi-64 grub_platforms_pc )"

RDEPEND="app-emulation/qemu
	dev-libs/libisoburn
	sys-fs/mtools
	sys-boot/grub:2[grub_platforms_efi-32?,grub_platforms_efi-64?,grub_platforms_pc?]
	grub_platforms_efi-32? (
		|| ( sys-firmware/edk2 sys-firmware/edk2-bin )
	)
	grub_platforms_efi-64? (
		|| ( sys-firmware/edk2 sys-firmware/edk2-bin )
	)
"
DEPEND="test? ( dev-python/parameterized[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
