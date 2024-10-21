# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info optfeature

DESCRIPTION="Automatic management of UEFI entries"
HOMEPAGE="https://github.com/Biosias/uefi-mkconfig"
SRC_URI="https://github.com/Biosias/uefi-mkconfig/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	app-shells/bash
	sys-boot/efibootmgr
"

CONFIG_CHECK="EFI_STUB"

src_install() {
	dobin uefi-mkconfig
	einstalldocs
}

pkg_postinst() {
	elog "uefi-mkconfig: Automatic management of UEFI entries"
	elog "Run uefi-mkconfig while having all efi partitions mounted"
	elog "Please use with care, this package was tested on a limited number of machines"
	elog "Some problems may arise due to different implementations of UEFI"
	elog "Don't forget to add kernel commands to the configuration file before using this package!"
	elog
	optfeature "Add UEFI entries on kernel installation " \ "sys-kernel/installkernel[-systemd,efistub]"
}
