# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{12..14} )

inherit edo prefix python-any-r1 readme.gentoo-r1 secureboot toolchain-funcs

DESCRIPTION="TianoCore EDK II UEFI firmware for virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

BUNDLED_BROTLI_SUBMODULE_SHA="e230f474b87134e8c6c85b630084c612057f253e"
BUNDLED_LIBFDT_SUBMODULE_SHA="cfff805481bdea27f900c32698171286542b8d3c"
BUNDLED_LIBSPDM_SUBMODULE_SHA="98ef964e1e9a0c39c7efb67143d3a13a819432e0"
BUNDLED_MBEDTLS_SUBMODULE_SHA="8c89224991adff88d53cd380f42a2baa36f91454"
BUNDLED_MIPI_SYS_T_SUBMODULE_SHA="370b5944c046bab043dd8b133727b2135af7747a"
BUNDLED_OPENSSL_SUBMODULE_P="openssl-3.5.1"

SBO_VER="1.6.3" # https://github.com/microsoft/secureboot_objects/releases
DBX_URI="https://github.com/microsoft/secureboot_objects/raw/refs/tags/v${SBO_VER}/PostSignedObjects/DBX/@ARCH@/DBXUpdate.bin -> @ARCH@_DBXUpdate_v${SBO_VER}.bin"

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

	amd64? ( ${DBX_URI//@ARCH@/amd64} )
	arm64? ( ${DBX_URI//@ARCH@/arm64} )

	!amd64? (
		https://github.com/devicetree-org/pylibfdt/archive/${BUNDLED_LIBFDT_SUBMODULE_SHA}.tar.gz
			-> pylibfdt-${BUNDLED_LIBFDT_SUBMODULE_SHA}.tar.gz
	)
"

S="${WORKDIR}/${PN}-${PN}-stable${PV}"
LICENSE="BSD-2-with-patent MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~loong ~riscv"

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
	"${FILESDIR}/${PN}-202511-werror.patch"
	"${FILESDIR}/${PN}-202502-nasm-3.patch"
	"${FILESDIR}/${PN}-202505-UninstallMemAttrProtocol.patch"
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
		ARCH_DIRS="${DIR}/ArmVirtQemu-AArch64"
		UNIT0="QEMU_EFI.qcow2"
		UNIT1="QEMU_VARS.qcow2"
		FMT="qcow2"
		;;
	loong)
		TARGET_ARCH="LOONGARCH64"
		QEMU_ARCH="loongarch64"
		ARCH_DIRS="${DIR}/LoongArchVirtQemu"
		UNIT0="QEMU_EFI.qcow2"
		UNIT1="QEMU_VARS.qcow2"
		FMT="qcow2"
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

	[[ -e ${DISTDIR}/pylibfdt-${BUNDLED_LIBFDT_SUBMODULE_SHA}.tar.gz ]] &&
		link_mod "${WORKDIR}/pylibfdt-${BUNDLED_LIBFDT_SUBMODULE_SHA}" \
			MdePkg/Library/BaseFdtLib/libfdt

	default

	# Fix descriptor paths for prefix.
	hprefixify "${FILESDIR}"/descriptors/*.json
}

my_build() {
	edo build \
		-t "${TOOLCHAIN}" \
		-b "${BUILD_TARGET}" \
		-a "${TARGET_ARCH}" \
		-D NETWORK_HTTP_BOOT_ENABLE \
		-D NETWORK_IP6_ENABLE \
		-D NETWORK_TLS_ENABLE \
		-D TPM1_ENABLE \
		-D TPM2_ENABLE \
		-D TPM2_CONFIG_ENABLE \
		"${BUILD_ARGS[@]}" \
		"${@}"
}

sb_build() {
	# DO NOT enable the shell with Secure Boot as it can be used as a bypass!
	my_build \
		-D BUILD_SHELL=FALSE \
		-D SECURE_BOOT_ENABLE \
		--pcd PcdDxeNxMemoryProtectionPolicy=0xC000000000007FD5 \
		--pcd PcdImageProtectionPolicy=0x03 \
		--pcd PcdNullPointerDetectionPropertyMask=0x03 \
		--pcd PcdSetNxForStack=TRUE \
		--pcd PcdUninstallMemAttrProtocol=FALSE \
		"${@}"
}

# Add the MS and Red Hat Secure Boot certificates and update the revocation list
# in the given raw variable images.
mk_fw_vars_raw() {
	local input args=() dbx="${DISTDIR}/${ARCH}_DBXUpdate_v${SBO_VER}.bin"
	[[ -e ${dbx} ]] && args+=( --set-dbx "${dbx}" )

	for input; do
		edo virt-fw-vars --secure-boot --enroll-redhat "${args[@]}" \
			--inplace "${input}"
	done
}

# Write the MS and Red Hat Secure Boot certificates and the revocation list to a
# JSON file for QEMU.
mk_fw_vars_json() {
	local args=() dbx="${DISTDIR}/${ARCH}_DBXUpdate_v${SBO_VER}.bin"
	[[ -e ${dbx} ]] && args+=( --set-dbx "${dbx}" )

	edo virt-fw-vars --secure-boot --enroll-redhat "${args[@]}" \
		--output-json "${S}/${ARCH}.qemuvars.json"
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

	case "${ARCH}" in
	amd64)
		local SIZE
		for SIZE in _2M _4M; do
			sb_build -p OvmfPkg/OvmfPkgX64.dsc \
				-D FD_SIZE${SIZE}B \
				-D SMM_REQUIRE

			mv -T Build/OvmfX64{,${SIZE}.secboot} || die

			# shim.efi has broken MemAttr code
			my_build -p OvmfPkg/OvmfPkgX64.dsc \
				-D FD_SIZE${SIZE}B \
				--pcd PcdDxeNxMemoryProtectionPolicy=0 \
				--pcd PcdUninstallMemAttrProtocol=TRUE

			mv -T Build/OvmfX64{,${SIZE}} || die

			mk_fw_vars_raw Build/OvmfX64${SIZE}.secboot/"${BUILD_DIR}"/FV/OVMF_VARS.fd
		done

		sb_build -p OvmfPkg/OvmfPkgX64.dsc \
			-D FD_SIZE_4MB \
			-D QEMU_PV_VARS

		mv -T Build/OvmfX64{,.qemuvars} || die

		# Fedora only converts newer images to QCOW2. 2MB images are raw.
		raw_to_qcow2 0 Build/OvmfX64{_4M*,.qemuvars}/"${BUILD_DIR}"/FV/OVMF_{CODE,VARS}.fd
		mk_fw_vars_json
		;;
	arm64)
		sb_build -p ArmVirtPkg/ArmVirtQemu.dsc
		mv -T Build/ArmVirtQemu-AArch64{,.secboot_INSECURE} || die

		sb_build -p ArmVirtPkg/ArmVirtQemu.dsc \
			-D QEMU_PV_VARS

		mv -T Build/ArmVirtQemu-AArch64{,.qemuvars} || die

		# shim.efi has broken MemAttr code
		my_build -p ArmVirtPkg/ArmVirtQemu.dsc \
			--pcd PcdDxeNxMemoryProtectionPolicy=0xC000000000007FD1 \
			--pcd PcdUninstallMemAttrProtocol=TRUE

		mk_fw_vars_raw Build/ArmVirtQemu-AArch64.secboot_INSECURE/"${BUILD_DIR}"/FV/QEMU_VARS.fd
		raw_to_qcow2 64m Build/ArmVirtQemu-AArch64*/"${BUILD_DIR}"/FV/QEMU_{EFI,VARS}.fd
		mk_fw_vars_json
		;;
	loong)
		my_build -p OvmfPkg/LoongArchVirt/LoongArchVirtQemu.dsc
		raw_to_qcow2 0 Build/LoongArchVirtQemu/"${BUILD_DIR}"/FV/QEMU_{EFI,VARS}.fd
		;;
	riscv)
		my_build -p OvmfPkg/RiscVVirt/RiscVVirtQemu.dsc
		raw_to_qcow2 32m Build/RiscVVirtQemu/"${BUILD_DIR}"/FV/RISCV_VIRT_{CODE,VARS}.fd
		;;
	esac

	# The standalone shell is safe so always build it.
	my_build -p ShellPkg/ShellPkg.dsc
}

src_install() {
	local SIZE TYPE FMT

	case "${ARCH}" in
	amd64)
		insinto ${DIR}/OvmfX64

		for SIZE in _2M _4M; do
			for TYPE in "" .secboot; do
				[[ ${SIZE} = _4M ]] && FMT=qcow2 || FMT=fd
				newins Build/OvmfX64${SIZE}${TYPE}/"${BUILD_DIR}"/FV/OVMF_CODE.${FMT} OVMF_CODE${SIZE#_2M}${TYPE}.${FMT}
				newins Build/OvmfX64${SIZE}${TYPE}/"${BUILD_DIR}"/FV/OVMF_VARS.${FMT} OVMF_VARS${SIZE#_2M}${TYPE}.${FMT}
			done
		done

		newins Build/OvmfX64.qemuvars/"${BUILD_DIR}"/FV/OVMF_CODE.qcow2 OVMF_CODE.qemuvars.qcow2
		newins amd64.qemuvars.json OVMF_VARS.qemuvars.json

		# Compatibility with older package versions.
		dosym ${PN}/OvmfX64 /usr/share/edk2-ovmf
		;;
	arm64)
		insinto ${DIR}/ArmVirtQemu-AARCH64

		for TYPE in "" .secboot_INSECURE; do
			newins Build/ArmVirtQemu-AArch64${TYPE}/"${BUILD_DIR}"/FV/QEMU_EFI.qcow2 QEMU_EFI${TYPE}.qcow2
			newins Build/ArmVirtQemu-AArch64${TYPE}/"${BUILD_DIR}"/FV/QEMU_VARS.qcow2 QEMU_VARS${TYPE}.qcow2
		done

		newins Build/ArmVirtQemu-AArch64.qemuvars/"${BUILD_DIR}"/FV/QEMU_EFI.qcow2 QEMU_EFI.qemuvars.qcow2
		newins arm64.qemuvars.json QEMU_VARS.qemuvars.json
		;;
	loong)
		insinto ${DIR}/LoongArchVirtQemu
		doins Build/LoongArchVirtQemu/"${BUILD_DIR}"/FV/QEMU_{EFI,VARS}.qcow2
		;;
	riscv)
		insinto ${DIR}/RiscVVirtQemu
		doins Build/RiscVVirtQemu/"${BUILD_DIR}"/FV/RISCV_VIRT_{CODE,VARS}.qcow2
		;;
	esac

	newins Build/Shell/"${BUILD_DIR}/${TARGET_ARCH}"/Shell_EA4BB293-2D7F-4456-A681-1F22F42CD0BC.efi Shell.efi

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
