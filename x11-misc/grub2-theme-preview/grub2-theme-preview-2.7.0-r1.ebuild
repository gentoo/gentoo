# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Preview a GRUB 2.x theme using KVM/QEMU"
HOMEPAGE="https://github.com/hartwork/grub2-theme-preview"
SRC_URI="https://github.com/hartwork/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="grub_platforms_efi-64"

RDEPEND="app-emulation/qemu
	dev-libs/libisoburn
	sys-fs/mtools
	grub_platforms_efi-64? (
		sys-boot/grub:2[grub_platforms_efi-64]
		sys-firmware/edk2-ovmf
	)
	!grub_platforms_efi-64? (
		sys-boot/grub:2[grub_platforms_pc]
	)
"
DEPEND="test? ( dev-python/parameterized[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
