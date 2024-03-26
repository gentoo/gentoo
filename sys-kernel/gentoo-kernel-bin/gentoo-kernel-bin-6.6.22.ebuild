# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_EFI_ZBOOT=1
KERNEL_IUSE_GENERIC_UKI=1
KERNEL_IUSE_SECUREBOOT=1

inherit kernel-install toolchain-funcs unpacker

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 6 ))
BINPKG=${PF/-bin}-1

DESCRIPTION="Pre-built Linux kernel with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
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

RDEPEND="
	!sys-kernel/gentoo-kernel:${SLOT}
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"
BDEPEND="
	app-alternatives/bc
	app-alternatives/lex
	virtual/libelf
	app-alternatives/yacc
"

QA_PREBUILT='*'

KV_LOCALVERSION='-gentoo-dist'
KPV=${PV}${KV_LOCALVERSION}

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	cd "${MY_P}" || die
	default
}

src_configure() {
	# force ld.bfd if we can find it easily
	local LD="$(tc-getLD)"
	if type -P "${LD}.bfd" &>/dev/null; then
		LD+=.bfd
	fi

	tc-export_build_env
	local makeargs=(
		V=1

		HOSTCC="$(tc-getBUILD_CC)"
		HOSTCXX="$(tc-getBUILD_CXX)"
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

		# we need to pass it to override colliding Gentoo envvar
		ARCH="$(tc-arch-kernel)"

		O="${WORKDIR}"/modprep
	)

	local kernel_dir="${BINPKG}/image/usr/src/linux-${KPV}"
	local image="${kernel_dir}/$(dist-kernel_get_image_path)"
	local uki="${image%/*}/uki.efi"
	if [[ -s ${uki} ]]; then
		# We need to extract the plain image for the test phase
		# and USE=-generic-uki.
		kernel-install_extract_from_uki linux "${uki}" "${image}"
	fi

	mkdir modprep || die
	cp "${kernel_dir}/.config" modprep/ || die
	emake -C "${MY_P}" "${makeargs[@]}" modules_prepare
}

src_test() {
	local kernel_dir="${BINPKG}/image/usr/src/linux-${KPV}"
	kernel-install_test "${KPV}" \
		"${WORKDIR}/${kernel_dir}/$(dist-kernel_get_image_path)" \
		"${BINPKG}/image/lib/modules/${KPV}"
}

src_install() {
	local kernel_dir="${BINPKG}/image/usr/src/linux-${KPV}"
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
	cp -p -R modprep/. "${ED}/usr/src/linux-${KPV}"/ || die

	# Update timestamps on all modules to ensure cleanup works correctly
	# when switching USE=modules-compress.
	find "${ED}/lib" -name '*.ko' -exec touch {} + || die

	# Modules were already stripped before signing
	dostrip -x /lib/modules
	kernel-install_compress_modules
}
