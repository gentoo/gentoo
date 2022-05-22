# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_LIBTOOL=none
inherit autotools

DESCRIPTION="Limine is a modern, advanced x86/x86_64 BIOS/UEFI multiprotocol bootloader."
HOMEPAGE="https://limine-bootloader.org/"
SRC_URI="https://limine-bootloader.org/files/limine/limine-${PV}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bios +bios-pxe +bios-cd +limine-deploy +uefi +cd-efi +uefi32 +uefi64"
REQUIRED_USE="
	uefi32? ( uefi )
	uefi64? ( uefi )
	cd-efi? ( uefi )
	uefi? ( || ( uefi32 uefi64 cd-efi ) )

	bios-pxe? ( bios )
	bios-cd? ( bios )
	limine-deploy? ( bios )
	bios? ( || ( bios-pxe bios-cd limine-deploy ) )
"

BDEPEND="
	sys-apps/findutils
	dev-lang/nasm
	app-arch/gzip
	cd-efi? ( sys-fs/mtools )
"

src_configure() {
	local myconf=(
		"$(use_enable bios)"
		"$(use_enable bios-cd)"
		"$(use_enable bios-pxe)"
		"$(use_enable limine-deploy)"

		"$(use_enable uefi)"
		"$(use_enable uefi32)"
		"$(use_enable uefi64)"
		"$(use_enable cd-efi)"
	)

	TOOLCHAIN="${CHOST}" \
	econf "${myconf[@]}"
}
