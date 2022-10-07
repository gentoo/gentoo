# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

BINPKG="${P/-bin/}-1"

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"
SRC_URI="https://dev.gentoo.org/~ajak/distfiles/${BINPKG}.xpak"
S="${WORKDIR}"

# TODO: the binary 202105 package currently lacks the preseeded
#       OVMF_VARS.secboot.fd file (that we typically get from fedora)

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="!sys-firmware/edk2-ovmf"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="This package contains the tianocore edk2 UEFI firmware for 64-bit x86
virtual machines. The firmware is located under
	/usr/share/edk2-ovmf/OVMF_CODE.fd
	/usr/share/edk2-ovmf/OVMF_VARS.fd
	/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd

If USE=binary is enabled, we also install an OVMF variables file (coming from
fedora) that contains secureboot default keys

	/usr/share/edk2-ovmf/OVMF_VARS.secboot.fd

If you have compiled this package by hand, you need to either populate all
necessary EFI variables by hand by booting
	/usr/share/edk2-ovmf/UefiShell.(iso|img)
or creating OVMF_VARS.secboot.fd by hand:
	https://github.com/puiterwijk/qemu-ovmf-secureboot

The firmware does not support csm (due to no free csm implementation
available). If you need a firmware with csm support you have to download
one for yourself. Firmware blobs are commonly labeled
	OVMF{,_CODE,_VARS}-with-csm.fd

In order to use the firmware you can run qemu the following way

	$ qemu-system-x86_64 \
		-drive file=/usr/share/edk2-ovmf/OVMF.fd,if=pflash,format=raw,unit=0,readonly=on \
		..."

src_unpack() {
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${BINPKG}.xpak") || die "unpacking binpkg failed"
}

src_install() {
	mv "usr/share/doc/${P/-bin/}" "usr/share/doc/${PF}" || die

	# Don't want to try to install the readme from the source package
	rm "usr/share/doc/${PF}/README.gentoo.bz2"
	mv usr "${ED}" || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
