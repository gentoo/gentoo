# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Fedora's signed UEFI shim"
HOMEPAGE="https://src.fedoraproject.org/rpms/shim"
SRC_URI="amd64? ( https://kojipkgs.fedoraproject.org/packages/shim/${PV}/2/x86_64/shim-x64-${PV}-2.x86_64.rpm
				https://kojipkgs.fedoraproject.org/packages/shim/${PV}/2/x86_64/shim-ia32-${PV}-2.x86_64.rpm )
		x86? ( https://kojipkgs.fedoraproject.org/packages/shim/${PV}/2/x86_64/shim-x64-${PV}-2.x86_64.rpm
				https://kojipkgs.fedoraproject.org/packages/shim/${PV}/2/x86_64/shim-ia32-${PV}-2.x86_64.rpm )
		arm64? ( https://kojipkgs.fedoraproject.org/packages/shim/${PV}/2/aarch64/shim-aa64-${PV}-2.aarch64.rpm )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

S="${WORKDIR}/boot/efi/EFI"

src_install() {
	insinto /usr/share/${PN}
	doins BOOT/BOOT*.EFI
	doins fedora/mm*.efi
}
