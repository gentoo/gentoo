# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RPM_COMPRESS_TYPE=zstd
inherit rpm secureboot

MAJORMINOR_V="$(ver_cut 1-2)"
PATCH_V="$(ver_cut 4)"

DESCRIPTION="Fedora's signed UEFI shim"
HOMEPAGE="https://src.fedoraproject.org/rpms/shim"
SRC_URI="
	amd64? (
		https://kojipkgs.fedoraproject.org/packages/shim/${MAJORMINOR_V}/${PATCH_V}/x86_64/shim-x64-${MAJORMINOR_V}-${PATCH_V}.x86_64.rpm
		https://kojipkgs.fedoraproject.org/packages/shim/${MAJORMINOR_V}/${PATCH_V}/x86_64/shim-ia32-${MAJORMINOR_V}-${PATCH_V}.x86_64.rpm
	)
	x86? (
		https://kojipkgs.fedoraproject.org/packages/shim/${MAJORMINOR_V}/${PATCH_V}/x86_64/shim-x64-${MAJORMINOR_V}-${PATCH_V}.x86_64.rpm
		https://kojipkgs.fedoraproject.org/packages/shim/${MAJORMINOR_V}/${PATCH_V}/x86_64/shim-ia32-${MAJORMINOR_V}-${PATCH_V}.x86_64.rpm
	)
	arm64? ( https://kojipkgs.fedoraproject.org/packages/shim/${MAJORMINOR_V}/${PATCH_V}/aarch64/shim-aa64-${MAJORMINOR_V}-${PATCH_V}.aarch64.rpm )"
S="${WORKDIR}/usr/lib/efi/shim/${MAJORMINOR_V}-${PATCH_V}/EFI"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

src_install() {
	insinto /usr/share/${PN}
	doins BOOT/BOOT*.EFI
	doins fedora/mm*.efi

	# Shim is already signed with Microsoft keys, but MokManager still needs
	# signing with our key otherwise we have to enrol the Fedora key in Mok list
	secureboot_auto_sign --in-place
}
