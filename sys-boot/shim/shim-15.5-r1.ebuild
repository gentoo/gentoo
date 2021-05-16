# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="Fedora's signed UEFI shim"
HOMEPAGE="https://apps.fedoraproject.org/packages/shim/"
MY_PV="${PV/./-}"
SRC_URI="amd64? ( https://kojipkgs.fedoraproject.org//packages/shim/15/5/x86_64/shim-x64-${MY_PV}.x86_64.rpm
				https://kojipkgs.fedoraproject.org//packages/shim/15/5/x86_64/shim-ia32-${MY_PV}.x86_64.rpm )
		x86? ( https://kojipkgs.fedoraproject.org//packages/shim/15/5/x86_64/shim-x64-${MY_PV}.x86_64.rpm
				https://kojipkgs.fedoraproject.org//packages/shim/15/5/x86_64/shim-ia32-${MY_PV}.x86_64.rpm )
		arm64? ( https://kojipkgs.fedoraproject.org//packages/shim/15/5/aarch64/shim-aa64-${MY_PV}.aarch64.rpm )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

S="${WORKDIR}/boot/efi/EFI"

src_install() {
	insinto /usr/share/${PN}
	doins BOOT/BOOT*.EFI
	doins fedora/mm*.efi
}
