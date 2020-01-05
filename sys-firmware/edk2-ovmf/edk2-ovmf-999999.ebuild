# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit eutils python-any-r1 readme.gentoo-r1

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

NON_BINARY_DEPEND="
	app-emulation/qemu
	>=dev-lang/nasm-2.0.7
	>=sys-power/iasl-20160729
	${PYTHON_DEPS}
"
DEPEND=""
RDEPEND=""
if [[ ${PV} == "999999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tianocore/edk2"
	DEPEND+="
		${NON_BINARY_DEPEND}
	"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
	IUSE="+binary"
	REQUIRED_USE+="
		!amd64? ( binary )
	"
	DEPEND+="
		!binary? (
			amd64? (
				${NON_BINARY_DEPEND}
			)
		)"
	PATCHES=(
	)
fi

LICENSE="BSD-2 MIT"
SLOT="0"

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
		...

You can register the firmware for use in libvirt by adding to /etc/libvirt/qemu.conf:
	nvram = [
		\"/usr/share/edk2-ovmf/OVMF_CODE.fd:/usr/share/edk2-ovmf/OVMF_VARS.fd\"
		\"/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd:/usr/share/edk2-ovmf/OVMF_VARS.fd\"
	]"

pkg_setup() {
	[[ ${PV} != "999999" ]] && use binary || python-any-r1_pkg_setup
}

src_prepare() {
	if  [[ ${PV} != "999999" ]] && use binary; then
		eapply_user
		return
	fi
	default
}

src_compile() {
	TARGET_ARCH=X64
	TARGET_NAME=RELEASE
	TARGET_TOOLS=GCC49

	BUILD_FLAGS="-D TLS_ENABLE \
		-D HTTP_BOOT_ENABLE \
		-D NETWORK_IP6_ENABLE \
		-D FD_SIZE_2MB"

	SECUREBOOT_BUILD_FLAGS="${BUILD_FLAGS} \
		-D SECURE_BOOT_ENABLE \
		-D SMM_REQUIRE \
		-D EXCLUDE_SHELL_FROM_FD"

	[[ ${PV} != "999999" ]] && use binary && return

	emake ARCH=${TARGET_ARCH} -C BaseTools

	. ./edksetup.sh

	# Build all EFI firmware blobs:

	mkdir -p ovmf

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		${BUILD_FLAGS} || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_*.fd ovmf/
	rm -rf Build/OvmfX64

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		${SECUREBOOT_BUILD_FLAGS} || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_CODE.fd ovmf/OVMF_CODE.secboot.fd || die "cp failed"
	cp Build/OvmfX64/*/X64/Shell.efi ovmf/ || die "cp failed"
	cp Build/OvmfX64/*/X64/EnrollDefaultKeys.efi ovmf || die "cp failed"

	# Build a convenience UefiShell.img:

	mkdir -p iso_image/efi/boot || die "mkdir failed"
	cp ovmf/Shell.efi iso_image/efi/boot/bootx64.efi || die "cp failed"
	cp ovmf/EnrollDefaultKeys.efi iso_image || die "cp failed"
	qemu-img convert --image-opts \
		driver=vvfat,floppy=on,fat-type=12,label=UEFI_SHELL,dir=iso_image \
		ovmf/UefiShell.img || die "qemu-img failed"
}

src_install() {
	insinto /usr/share/${PN}
	doins ovmf/*

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
