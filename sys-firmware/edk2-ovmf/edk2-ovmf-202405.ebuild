# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_12 )

inherit python-any-r1 readme.gentoo-r1 secureboot

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

BUNDLED_OPENSSL_SUBMODULE_SHA="de90e54bbe82e5be4fb9608b6f5c308bb837d355"
BUNDLED_BROTLI_SUBMODULE_SHA="f4153a09f87cbb9c826d8fc12c74642bb2d879ea"
BUNDLED_MIPI_SYS_T_SUBMODULE_SHA="370b5944c046bab043dd8b133727b2135af7747a"
BUNDLED_MBEDTLS_SUBMODULE_SHA="8c89224991adff88d53cd380f42a2baa36f91454"
BUNDLED_LIBSPDM_SUBMODULE_SHA="828ef62524bcaeca4e90d0c021221e714872e2b5"

SRC_URI="https://github.com/tianocore/edk2/archive/edk2-stable${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/openssl/openssl/archive/${BUNDLED_OPENSSL_SUBMODULE_SHA}.tar.gz -> openssl-${BUNDLED_OPENSSL_SUBMODULE_SHA}.tar.gz
	https://github.com/google/brotli/archive/${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz -> brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz
	https://github.com/MIPI-Alliance/public-mipi-sys-t/archive/${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}.tar.gz -> mipi-sys-t-${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}.tar.gz
	https://github.com/Mbed-TLS/mbedtls/archive/${BUNDLED_MBEDTLS_SUBMODULE_SHA}.tar.gz -> mbedtls-${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}.tar.gz
	https://github.com/DMTF/libspdm/archive/${BUNDLED_LIBSPDM_SUBMODULE_SHA}.tar.gz -> libspdm-${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}.tar.gz
	https://dev.gentoo.org/~ajak/distfiles/${PN}-202202-qemu-firmware.tar.xz"

S="${WORKDIR}/edk2-edk2-stable${PV}"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

BDEPEND="app-emulation/qemu
	>=dev-lang/nasm-2.0.7
	>=sys-power/iasl-20160729
	${PYTHON_DEPS}"
RDEPEND="!sys-firmware/edk2-ovmf-bin"

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

pkg_setup() {
	python-any-r1_pkg_setup
	secureboot_pkg_setup
}

src_prepare() {
	# Bundled submodules
	cp -rl "${WORKDIR}/openssl-${BUNDLED_OPENSSL_SUBMODULE_SHA}"/* "CryptoPkg/Library/OpensslLib/openssl/" \
		|| die "copying openssl failed"
	cp -rl "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}"/* "BaseTools/Source/C/BrotliCompress/brotli/" \
		|| die "copying brotli failed"
	cp -rl "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}"/* \
		"MdeModulePkg/Library/BrotliCustomDecompressLib/brotli/" || die "copying brotli failed"
	cp -rl "${WORKDIR}/public-mipi-sys-t-${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}"/* "MdePkg/Library/MipiSysTLib/mipisyst/" \
		|| die "copying mipi-sys-t failed"
	cp -rl "${WORKDIR}/mbedtls-${BUNDLED_MBEDTLS_SUBMODULE_SHA}"/* "CryptoPkg/Library/MbedTlsLib/mbedtls/" \
		|| die "copying mbedtls failed"
	cp -rl "${WORKDIR}/libspdm-${BUNDLED_LIBSPDM_SUBMODULE_SHA}"/* "SecurityPkg/DeviceSecurity/SpdmLib/libspdm" \
		|| die "copying libspdm failed"

	default
}

src_compile() {
	TARGET_ARCH=X64
	TARGET_NAME=RELEASE
	TARGET_TOOLS=GCC5

	BUILD_FLAGS="-D TLS_ENABLE \
		-D HTTP_BOOT_ENABLE \
		-D NETWORK_IP6_ENABLE \
		-D TPM_ENABLE \
		-D TPM2_ENABLE -D TPM2_CONFIG_ENABLE \
		-D FD_SIZE_2MB"

	SECUREBOOT_BUILD_FLAGS="${BUILD_FLAGS} \
		-D SECURE_BOOT_ENABLE \
		-D SMM_REQUIRE \
		-D EXCLUDE_SHELL_FROM_FD"

	export LDFLAGS="-z notext"
	export EXTRA_LDFLAGS="-z notext"
	export DLINK_FLAGS="-z notext"

	emake ARCH=${TARGET_ARCH} -C BaseTools

	. ./edksetup.sh

	# Build all EFI firmware blobs:

	mkdir -p ovmf || die

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		${BUILD_FLAGS} || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_*.fd ovmf/
	rm -r Build/OvmfX64 || die

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

	insinto /usr/share/qemu/firmware
	doins "${S}"/../edk2-edk2-stable202202/qemu/*
	rm "${ED}"/usr/share/qemu/firmware/40-edk2-ovmf-x64-sb-enrolled.json || die "rm failed"

	secureboot_auto_sign --in-place

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
