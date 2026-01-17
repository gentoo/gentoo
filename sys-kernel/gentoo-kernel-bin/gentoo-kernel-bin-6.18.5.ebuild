# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1

inherit kernel-install toolchain-funcs unpacker verify-sig

BASE_P=linux-${PV%.*}
PATCH_PV=${PV%_p*}
PATCHSET=linux-gentoo-patches-6.18.4
BINPKG=${P/-bin}-1
SHA256SUM_DATE=20260112

DESCRIPTION="Pre-built Linux kernel with Gentoo patches"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${BASE_P}.tar.xz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PATCH_PV}.xz
	https://dev.gentoo.org/~mgorny/dist/linux/${PATCHSET}.tar.xz
	verify-sig? (
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/sha256sums.asc
			-> linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc
	)
	amd64? (
		https://dev.gentoo.org/~mgorny/binpkg/amd64/kernel/sys-kernel/gentoo-kernel/${BINPKG}.gpkg.tar
			-> ${BINPKG}.amd64.gpkg.tar
	)
	arm64? (
		https://dev.gentoo.org/~mgorny/binpkg/arm64/kernel/sys-kernel/gentoo-kernel/${BINPKG}.gpkg.tar
			-> ${BINPKG}.arm64.gpkg.tar
	)
	ppc64? (
		https://dev.gentoo.org/~mgorny/binpkg/ppc64le/kernel/sys-kernel/gentoo-kernel/${BINPKG}.gpkg.tar
			-> ${BINPKG}.ppc64le.gpkg.tar
	)
	x86? (
		https://dev.gentoo.org/~mgorny/binpkg/x86/kernel/sys-kernel/gentoo-kernel/${BINPKG}.gpkg.tar
			-> ${BINPKG}.x86.gpkg.tar
	)
"
S=${WORKDIR}

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="debug"

RDEPEND="
	!sys-kernel/gentoo-kernel:${SLOT}
"
PDEPEND="
	>=virtual/dist-kernel-${PATCH_PV}
"
BDEPEND="
	app-alternatives/bc
	app-alternatives/lex
	dev-util/pahole
	virtual/libelf
	app-alternatives/yacc
	amd64? ( app-crypt/sbsigntools )
	arm64? ( app-crypt/sbsigntools )
	verify-sig? ( >=sec-keys/openpgp-keys-kernel-20250702 )
"

KV_LOCALVERSION='-gentoo-dist'
KV_FULL=${PV/_p/-p}${KV_LOCALVERSION}

QA_PREBUILT='*'

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kernel.org.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc" \
			sha256 "${BASE_P}.tar.xz patch-${PATCH_PV}.xz"
		cd "${WORKDIR}" || die
	fi

	unpacker
}

src_prepare() {
	local patch
	cd "${BASE_P}" || die
	eapply "${WORKDIR}/patch-${PATCH_PV}"
	for patch in "${WORKDIR}/${PATCHSET}"/*.patch; do
		eapply "${patch}"
		# non-experimental patches always finish with Gentoo Kconfig
		# we built -bins without them
		if [[ ${patch} == *Add-Gentoo-Linux-support-config-settings* ]]
		then
			break
		fi
	done

	default

	# add Gentoo patchset version
	local extraversion=${PV#${PATCH_PV}}
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${extraversion/_/-}:" Makefile || die
}

src_configure() {
	# force ld.bfd if we can find it easily
	local HOSTLD="$(tc-getBUILD_LD)"
	if type -P "${HOSTLD}.bfd" &>/dev/null; then
		HOSTLD+=.bfd
	fi
	local LD="$(tc-getLD)"
	if type -P "${LD}.bfd" &>/dev/null; then
		LD+=.bfd
	fi
	tc-export_build_env
	local makeargs=(
		V=1
		WERROR=0

		HOSTCC="$(tc-getBUILD_CC)"
		HOSTCXX="$(tc-getBUILD_CXX)"
		HOSTLD="${HOSTLD}"
		HOSTAR="$(tc-getBUILD_AR)"
		HOSTCFLAGS="${BUILD_CFLAGS}"
		HOSTLDFLAGS="${BUILD_LDFLAGS}"

		CROSS_COMPILE=${CHOST}-
		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		LD="${LD}"
		AR="$(tc-getAR)"
		NM="$(tc-getNM)"
		STRIP="$(tc-getSTRIP)"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"
		READELF="$(tc-getREADELF)"

		# we need to pass it to override colliding Gentoo envvar
		ARCH="$(tc-arch-kernel)"

		O="${WORKDIR}"/modprep
	)

	local kernel_dir="${BINPKG}/image/usr/src/linux-${KV_FULL}"

	# If this is set it will have an effect on the name of the output
	# image. Set this variable to track this setting.
	if grep -q "CONFIG_EFI_ZBOOT=y" "${kernel_dir}/.config"; then
		KERNEL_EFI_ZBOOT=1
	elif use arm64 && use generic-uki; then
		die "USE=generic-uki requires a CONFIG_EFI_ZBOOT enabled build"
	fi

	local image="${kernel_dir}/$(dist-kernel_get_image_path)"
	local uki="${image%/*}/uki.efi"

	# Override user variable with the cert used during build
	openssl x509 \
		-inform DER -in "${kernel_dir}/certs/signing_key.x509" \
		-outform PEM -out "${T}/cert.pem" ||
			die "Failed to convert pcrpkey to PEM format"
	export SECUREBOOT_SIGN_CERT=${T}/cert.pem

	if [[ -s ${uki} ]]; then
		# We need to extract the plain image for the test phase
		# and USE=-generic-uki.
		kernel-install_extract_from_uki linux "${uki}" "${image}"
	fi

	mkdir modprep || die
	cp "${kernel_dir}/.config" modprep/ || die
	emake -C "${BASE_P}" "${makeargs[@]}" modules_prepare
}

src_test() {
	local kernel_dir="${BINPKG}/image/usr/src/linux-${KV_FULL}"
	kernel-install_test "${KV_FULL}" \
		"${WORKDIR}/${kernel_dir}/$(dist-kernel_get_image_path)" \
		"${BINPKG}/image/lib/modules/${KV_FULL}"
}

src_install() {
	local rel_kernel_dir=/usr/src/linux-${KV_FULL}
	local kernel_dir="${BINPKG}/image${rel_kernel_dir}"
	local image="${kernel_dir}/$(dist-kernel_get_image_path)"
	local uki="${image%/*}/uki.efi"
	if [[ -s ${uki} ]]; then
		# Keep the kernel image type we don't want out of install tree
		# Replace back with placeholder
		if use generic-uki; then
			> "${image}" || die
		else
			> "${uki}" || die
		fi
	fi

	# Overwrite the identifier in the prebuilt package
	echo "${CATEGORY}/${PF}:${SLOT}" > "${kernel_dir}/dist-kernel" || die

	mv "${BINPKG}"/image/{lib,usr} "${ED}"/ || die

	# FIXME: requires proper mount-boot
	if [[ -d ${BINPKG}/image/boot/dtbs ]]; then
		mv "${BINPKG}"/image/boot "${ED}"/ || die
	fi

	# strip out-of-source build stuffs from modprep
	# and then copy built files
	find modprep -type f '(' \
			-name Makefile -o \
			-name '*.[ao]' -o \
			'(' -name '.*' -a -not -name '.config' ')' \
		')' -delete || die
	rm modprep/source || die
	cp -p -R modprep/. "${ED}${rel_kernel_dir}"/ || die

	# Update timestamps on all modules to ensure cleanup works correctly
	# when switching USE=modules-compress.
	find "${ED}/lib" -name '*.ko' -exec touch {} + || die

	# Modules were already stripped before signing
	dostrip -x /lib/modules
	kernel-install_compress_modules

	# Mirror the logic from kernel-build_src_install, for architectures
	# where USE=debug is used.
	if use ppc64; then
		dostrip -x "${rel_kernel_dir}/$(dist-kernel_get_image_path)"
	elif use debug && { use amd64 || use arm64; }; then
		dostrip -x "${rel_kernel_dir}/vmlinux"
		dostrip -x "${rel_kernel_dir}/vmlinux.ctfa"
	fi
}
