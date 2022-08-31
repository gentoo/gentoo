# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-install toolchain-funcs

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 9 ))
BINPKG=${P/-bin/}-1

DESCRIPTION="Pre-built Linux kernel with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	amd64? (
		https://dev.gentoo.org/~mgorny/binpkg/amd64/kernel/sys-kernel/gentoo-kernel/${BINPKG}.xpak
			-> ${BINPKG}.amd64.xpak
	)
	arm64? (
		https://dev.gentoo.org/~mgorny/binpkg/arm64/kernel/sys-kernel/gentoo-kernel/${BINPKG}.xpak
			-> ${BINPKG}.arm64.xpak
	)
	ppc64? (
		https://dev.gentoo.org/~mgorny/binpkg/ppc64le/kernel/sys-kernel/gentoo-kernel/${BINPKG}.xpak
			-> ${BINPKG}.ppc64le.xpak
	)
	x86? (
		https://dev.gentoo.org/~mgorny/binpkg/x86/kernel/sys-kernel/gentoo-kernel/${BINPKG}.xpak
			-> ${BINPKG}.x86.xpak
	)
"
S=${WORKDIR}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

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
	virtual/yacc
"

QA_PREBUILT='*'

KV_LOCALVERSION='-gentoo-dist'
KPV=${PV}${KV_LOCALVERSION}

src_unpack() {
	default
	# ARCH=ppc64, but tarball is ppc64le. Update if we ever introduce ppc64be binpkg.
	ebegin "Unpacking ${BINPKG}.${ARCH/%ppc64/ppc64le}.xpak"
	tar -x < <(xz -c -d --single-stream "${DISTDIR}/${BINPKG}.${ARCH/%ppc64/ppc64le}.xpak")
	eend ${?} || die "Unpacking ${BINPKG} failed"
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
		STRIP=":"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"

		# we need to pass it to override colliding Gentoo envvar
		ARCH="$(tc-arch-kernel)"

		O="${WORKDIR}"/modprep
	)

	mkdir modprep || die
	cp "usr/src/linux-${KPV}/.config" modprep/ || die
	emake -C "${MY_P}" "${makeargs[@]}" modules_prepare
}

src_test() {
	kernel-install_test "${KPV}" \
		"${WORKDIR}/usr/src/linux-${KPV}/$(dist-kernel_get_image_path)" \
		"lib/modules/${KPV}"
}

src_install() {
	mv lib usr "${ED}"/ || die

	# FIXME: requires proper mount-boot
	if [[ -d boot/dtbs ]]; then
		mv boot "${ED}"/ || die
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
}
