# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_SECUREBOOT=1
MODULES_NO_KERNEL_DEPS=1
inherit kernel-install linux-mod-r1 toolchain-funcs secureboot unpacker

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 2 ))
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

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
REQUIRED_USE="secureboot? ( modules-sign )"

RDEPEND="
	!sys-kernel/gentoo-kernel:${SLOT}
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"
BDEPEND="
	sys-devel/bc
	sys-devel/flex
	virtual/libelf
	app-alternatives/yacc
"

QA_PREBUILT='*'

KV_LOCALVERSION='-gentoo-dist'
KPV=${PV}${KV_LOCALVERSION}

pkg_setup() {
	secureboot_pkg_setup
}

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

	mkdir modprep || die
	cp "${BINPKG}/image/usr/src/linux-${KPV}/.config" modprep/ || die
	emake -C "${MY_P}" "${makeargs[@]}" modules_prepare
}

src_compile() {
	:
}

src_test() {
	kernel-install_test "${KPV}" \
		"${WORKDIR}/${BINPKG}/image/usr/src/linux-${KPV}/$(dist-kernel_get_image_path)" \
		"${BINPKG}/image/lib/modules/${KPV}"
}

src_install() {
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

	# We can only call linux-mod-r1_pkg_setup after we have
	# setup our kernel sources
	local KERNEL_DIR="${ED}/usr/src/linux-${KPV}"
	linux-mod-r1_pkg_setup
	modules_post_process
}

pkg_postinst() {
	kernel-install_pkg_postinst
}
