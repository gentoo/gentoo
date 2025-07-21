# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{12..13} )

inherit edo prefix python-any-r1 readme.gentoo-r1 secureboot toolchain-funcs

DESCRIPTION="TianoCore EDK II UEFI firmware for virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

DBXDATE="05092023" # MMDDYYYY
BUNDLED_BROTLI_SUBMODULE_SHA="f4153a09f87cbb9c826d8fc12c74642bb2d879ea"
BUNDLED_LIBFDT_SUBMODULE_SHA="cfff805481bdea27f900c32698171286542b8d3c"
BUNDLED_LIBSPDM_SUBMODULE_SHA="50924a4c8145fc721e17208f55814d2b38766fe6"
BUNDLED_MBEDTLS_SUBMODULE_SHA="8c89224991adff88d53cd380f42a2baa36f91454"
BUNDLED_MIPI_SYS_T_SUBMODULE_SHA="370b5944c046bab043dd8b133727b2135af7747a"
BUNDLED_OPENSSL_SUBMODULE_P="openssl-3.0.15"

SRC_URI="
	https://github.com/tianocore/${PN}/archive/${PN}-stable${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/google/brotli/archive/${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz
		-> brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz
	https://github.com/DMTF/libspdm/archive/${BUNDLED_LIBSPDM_SUBMODULE_SHA}.tar.gz
		-> libspdm-${BUNDLED_LIBSPDM_SUBMODULE_SHA}.tar.gz
	https://github.com/Mbed-TLS/mbedtls/archive/${BUNDLED_MBEDTLS_SUBMODULE_SHA}.tar.gz
		-> mbedtls-${BUNDLED_MBEDTLS_SUBMODULE_SHA}.tar.gz
	https://github.com/MIPI-Alliance/public-mipi-sys-t/archive/${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}.tar.gz
		-> mipi-sys-t-${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}.tar.gz
	https://github.com/openssl/openssl/releases/download/${BUNDLED_OPENSSL_SUBMODULE_P}/${BUNDLED_OPENSSL_SUBMODULE_P}.tar.gz

	amd64? (
		https://uefi.org/sites/default/files/resources/x64_DBXUpdate_${DBXDATE}.bin
		https://uefi.org/sites/default/files/resources/x64_DBXUpdate.bin -> x64_DBXUpdate_${DBXDATE}.bin
	)

	arm64? (
		https://uefi.org/sites/default/files/resources/arm64_DBXUpdate_${DBXDATE}.bin
		https://uefi.org/sites/default/files/resources/arm64_DBXUpdate.bin -> arm64_DBXUpdate_${DBXDATE}.bin
		https://github.com/devicetree-org/pylibfdt/archive/${BUNDLED_LIBFDT_SUBMODULE_SHA}.tar.gz
			-> pylibfdt-${BUNDLED_LIBFDT_SUBMODULE_SHA}.tar.gz
	)
"

S="${WORKDIR}/${PN}-${PN}-stable${PV}"
LICENSE="BSD-2-with-patent MIT"
SLOT="0"
KEYWORDS="-* amd64 arm64 ~loong ~riscv"

BDEPEND="
	${PYTHON_DEPS}
	app-emulation/qemu
	app-emulation/virt-firmware
	>=sys-power/iasl-20160729
	amd64? ( >=dev-lang/nasm-2.0.7 )
"

RDEPEND="
	!sys-firmware/edk2-bin
"

PATCHES=(
	"${FILESDIR}/${PN}-202411-werror.patch"
	"${FILESDIR}/${PN}-202411-gcc15.patch"
	"${FILESDIR}/${PN}-202411-loong.patch"
	"${FILESDIR}/${PN}-202408-binutils-2.41-textrels.patch"
)

DISABLE_AUTOFORMATTING="true"
DIR="/usr/share/${PN}"

pkg_setup() {
	python-any-r1_pkg_setup
	secureboot_pkg_setup

	local QEMU_ARCH ARCH_DIRS UNIT0 UNIT1 FMT

	case "${ARCH}" in
	amd64)
		TARGET_ARCH="X64"
		QEMU_ARCH="x86_64"
		ARCH_DIRS="${DIR}/OvmfX64"
		UNIT0="OVMF_CODE.fd"
		UNIT1="OVMF_VARS.fd"
		FMT="raw"
		;;
	arm64)
		TARGET_ARCH="AARCH64"
		QEMU_ARCH="aarch64"
		ARCH_DIRS="${DIR}/ArmVirtQemu-AARCH64"
		UNIT0="QEMU_EFI.qcow2"
		UNIT1="QEMU_VARS.qcow2"
		FMT="qcow2"
		;;
	loong)
		TARGET_ARCH="LOONGARCH64"
		QEMU_ARCH="loongarch64"
		ARCH_DIRS="${DIR}/LoongArchVirtQemu"
		UNIT0="QEMU_EFI.fd"
		UNIT1="QEMU_VARS.fd"
		FMT="raw"
		;;
	riscv)
		TARGET_ARCH="RISCV64"
		QEMU_ARCH="riscv64"
		ARCH_DIRS="${DIR}/RiscVVirtQemu"
		UNIT0="RISCV_VIRT_CODE.qcow2"
		UNIT1="RISCV_VIRT_VARS.qcow2"
		FMT="qcow2"
		;;
	esac

	DOC_CONTENTS="This package includes the TianoCore EDK II UEFI firmware for ${QEMU_ARCH}
virtual machines. The firmware is located under ${ARCH_DIRS}.

In order to use the firmware, you can run QEMU like so:

	$ qemu-system-${QEMU_ARCH} \\
		-drive file=${EPREFIX}${ARCH_DIRS%% *}/${UNIT0},if=pflash,format=${FMT},unit=0,readonly=on \\
		-drive file=/path/to/the/copy/of/${UNIT1},if=pflash,format=${FMT},unit=1 \\
		..."

	case "${ARCH}" in
	amd64) DOC_CONTENTS+="

The firmware does not support CSM due to the lack of a free
implementation. If you need a firmware with CSM support, you have to
download one for yourself. Firmware blobs are commonly labelled:

	OVMF_CODE-with-csm.fd
	OVMF_VARS-with-csm.fd"
		;;
	arm64) DOC_CONTENTS+="

WARNING! QEMU_EFI.secboot_INSECURE.qcow2 does have Secure Boot
enabled, but it must not be used in production. The lack of an SMM
implementation for arm64 in this firmware means that the EFI
variable store is unprotected, making the firmware unsafe."
		;;
	esac
}

link_mod() {
	rmdir "$2" && ln -sfT "$1" "$2" || die "linking ${2##*/} failed"
}

src_prepare() {
	# Bundled submodules
	link_mod "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}" \
		BaseTools/Source/C/BrotliCompress/brotli
	link_mod "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}" \
		MdeModulePkg/Library/BrotliCustomDecompressLib/brotli
	link_mod "${WORKDIR}/libspdm-${BUNDLED_LIBSPDM_SUBMODULE_SHA}" \
		SecurityPkg/DeviceSecurity/SpdmLib/libspdm
	link_mod "${WORKDIR}/mbedtls-${BUNDLED_MBEDTLS_SUBMODULE_SHA}" \
		CryptoPkg/Library/MbedTlsLib/mbedtls
	link_mod "${WORKDIR}/public-mipi-sys-t-${BUNDLED_MIPI_SYS_T_SUBMODULE_SHA}" \
		MdePkg/Library/MipiSysTLib/mipisyst
	link_mod "${WORKDIR}/${BUNDLED_OPENSSL_SUBMODULE_P}" \
		CryptoPkg/Library/OpensslLib/openssl

	use arm64 &&
		link_mod "${WORKDIR}/pylibfdt-${BUNDLED_LIBFDT_SUBMODULE_SHA}" \
			MdePkg/Library/BaseFdtLib/libfdt

	default

	# Fix descriptor paths for prefix.
	hprefixify "${FILESDIR}"/descriptors/*.json
}

mybuild() {
	edo build \
		-t "${TOOLCHAIN}" \
		-b "${BUILD_TARGET}" \
		-D NETWORK_HTTP_BOOT_ENABLE \
		-D NETWORK_IP6_ENABLE \
		-D NETWORK_TLS_ENABLE \
		-D TPM1_ENABLE \
		-D TPM2_ENABLE \
		-D TPM2_CONFIG_ENABLE \
		"${BUILD_ARGS[@]}" \
		"${@}"
}

# Add the MS and Red Hat Secure Boot certificates and update the revocation list
# for the given architecture in the given raw variables image.
mk_fw_vars() {
	edo virt-fw-vars \
		--set-dbx "${DISTDIR}/$1_DBXUpdate_${DBXDATE}.bin" \
		--secure-boot --enroll-redhat --inplace "$2"
}

# Convert the given images from raw to QCOW2 and resize them to the amount given
# as the first argument. Specify 0 to not resize.
raw_to_qcow2() {
	local SIZE=$1 RAW
	shift

	for RAW in "${@}"; do
		edo qemu-img convert -f raw -O qcow2 -o cluster_size=4096 -S 4096 "${RAW}" "${RAW%.fd}.qcow2"
		[[ ${SIZE} != 0 ]] && edo qemu-img resize -f qcow2 "${RAW%.fd}.qcow2" "${SIZE}"
		rm "${RAW}" || die
	done
}

src_compile() {
	TOOLCHAIN="GCC5"
	BUILD_TARGET="RELEASE"
	BUILD_DIR="${BUILD_TARGET}_${TOOLCHAIN}"
	BUILD_ARGS=()

	tc-export_build_env
	emake -C BaseTools \
		CC="$(tc-getBUILD_CC)" \
		CXX="$(tc-getBUILD_CXX)" \
		EXTRA_OPTFLAGS="${BUILD_CFLAGS}" \
		EXTRA_LDFLAGS="${BUILD_LDFLAGS}"

	export \
		"${TOOLCHAIN}_${TARGET_ARCH}_PREFIX=${CHOST}-" \
		"${TOOLCHAIN}_BIN=${CHOST}-"

	. ./edksetup.sh

	# DO NOT enable the shell with Secure Boot as it can be used as a bypass!

	case "${ARCH}" in
	amd64)
		local SIZE
		for SIZE in _2M _4M; do
			mybuild -a X64 -p OvmfPkg/OvmfPkgX64.dsc \
				-D FD_SIZE${SIZE}B \
				-D BUILD_SHELL=FALSE \
				-D SECURE_BOOT_ENABLE \
				-D SMM_REQUIRE

			mv -T Build/OvmfX64 Build/OvmfX64${SIZE}.secboot || die

			mybuild -a X64 -p OvmfPkg/OvmfPkgX64.dsc \
				-D FD_SIZE${SIZE}B

			mv -T Build/OvmfX64 Build/OvmfX64${SIZE} || die

			mk_fw_vars x64 Build/OvmfX64${SIZE}.secboot/"${BUILD_DIR}"/FV/OVMF_VARS.fd
		done

		# Fedora only converts newer images to QCOW2. 2MB images are raw.
		raw_to_qcow2 0 Build/OvmfX64_4M*/"${BUILD_DIR}"/FV/OVMF_{CODE,VARS}.fd
		;;
	arm64)
		BUILD_ARGS+=(
			# grub.efi uses EfiLoaderData for code
			--pcd PcdDxeNxMemoryProtectionPolicy=0xC000000000007FD1
			# shim.efi has broken MemAttr code
			--pcd PcdUninstallMemAttrProtocol=TRUE
		)

		mybuild -a AARCH64 -p ArmVirtPkg/ArmVirtQemu.dsc \
			-D BUILD_SHELL=FALSE \
			-D SECURE_BOOT_ENABLE

		mv -T Build/ArmVirtQemu-AARCH64 Build/ArmVirtQemu-AARCH64.secboot_INSECURE || die

		mybuild -a AARCH64 -p ArmVirtPkg/ArmVirtQemu.dsc

		mk_fw_vars arm64 Build/ArmVirtQemu-AARCH64.secboot_INSECURE/"${BUILD_DIR}"/FV/QEMU_VARS.fd
		raw_to_qcow2 64m Build/ArmVirtQemu-AARCH64*/"${BUILD_DIR}"/FV/QEMU_{EFI,VARS}.fd
		;;
	loong)
		BUILD_ARGS+=(
			# fails to seed the OpenSSL RNG during early initialization due
			# to improper FPU enabling (maybe too late)
			-D NETWORK_TLS_ENABLE=FALSE
		)
		mybuild -a LOONGARCH64 -p OvmfPkg/LoongArchVirt/LoongArchVirtQemu.dsc
		;;
	riscv)
		mybuild -a RISCV64 -p OvmfPkg/RiscVVirt/RiscVVirtQemu.dsc
		raw_to_qcow2 32m Build/RiscVVirtQemu/"${BUILD_DIR}"/FV/RISCV_VIRT_{CODE,VARS}.fd
		;;
	esac
}

src_install() {
	local SIZE TYPE FMT

	case "${ARCH}" in
	amd64)
		insinto ${DIR}/OvmfX64
		doins Build/OvmfX64_2M/"${BUILD_DIR}"/X64/Shell.efi

		for SIZE in _2M _4M; do
			for TYPE in "" .secboot; do
				[[ ${SIZE} = _4M ]] && FMT=qcow2 || FMT=fd
				newins Build/OvmfX64${SIZE}${TYPE}/"${BUILD_DIR}"/FV/OVMF_CODE.${FMT} OVMF_CODE${SIZE#_2M}${TYPE}.${FMT}
				newins Build/OvmfX64${SIZE}${TYPE}/"${BUILD_DIR}"/FV/OVMF_VARS.${FMT} OVMF_VARS${SIZE#_2M}${TYPE}.${FMT}
			done
		done

		# Compatibility with older package versions.
		dosym ${PN}/OvmfX64 /usr/share/edk2-ovmf
		;;
	arm64)
		insinto ${DIR}/ArmVirtQemu-AARCH64

		for TYPE in "" .secboot_INSECURE; do
			newins Build/ArmVirtQemu-AARCH64${TYPE}/"${BUILD_DIR}"/FV/QEMU_EFI.qcow2 QEMU_EFI${TYPE}.qcow2
			newins Build/ArmVirtQemu-AARCH64${TYPE}/"${BUILD_DIR}"/FV/QEMU_VARS.qcow2 QEMU_VARS${TYPE}.qcow2
		done
		;;
	loong)
		insinto ${DIR}/LoongArchVirtQemu
		doins Build/LoongArchVirtQemu/"${BUILD_DIR}"/FV/QEMU_{EFI,VARS}.fd
		;;
	riscv)
		insinto ${DIR}/RiscVVirtQemu
		doins Build/RiscVVirtQemu/"${BUILD_DIR}"/FV/RISCV_VIRT_{CODE,VARS}.qcow2
		;;
	esac

	insinto /usr/share/qemu/firmware
	doins "${FILESDIR}"/descriptors/*"${TARGET_ARCH,,}"*.json

	secureboot_auto_sign --in-place
	readme.gentoo_create_doc
}

pkg_preinst() {
	local OLD=${EROOT}/usr/share/edk2-ovmf NEW=${EROOT}/${DIR}/OvmfX64
	if [[ -d ${OLD} && ! -L ${OLD} ]]; then
		{
			rm -vf "${OLD}"/{OVMF_{CODE,CODE.secboot,VARS}.fd,EnrollDefaultKeys.efi,Shell.efi,UefiShell.img} &&
			mkdir -p "${NEW}" &&
			find "${OLD}" -mindepth 1 -maxdepth 1 -execdir mv --update=none-fail -vt "${NEW}"/ {} + &&
			rmdir "${OLD}"
		} || die "unable to replace old directory with compatibility symlink"
	fi
}

pkg_postinst() {
	readme.gentoo_print_elog
}
