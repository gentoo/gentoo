# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dist-kernel-utils toolchain-funcs verify-sig

BASE_P=linux-${PV%.*}
PATCH_PV=${PV%_p*}
PATCHSET=linux-gentoo-patches-6.12.95
SHA256SUM_DATE=20260718

DESCRIPTION="Minimal subset of gentoo-kernel-bin for building modules, for containers"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${BASE_P}.tar.xz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PATCH_PV}.xz
	https://distfiles.gentoo.org/pub/proj/dist-kernel/patchsets/$(ver_cut 1-2)/${PATCHSET}.tar.xz
	https://distfiles.gentoo.org/pub/proj/dist-kernel/binpkg/modprep/$(ver_cut 1-2)/${P}.tar.xz
	verify-sig? (
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/sha256sums.asc
			-> linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc
	)
"
S=${WORKDIR}

LICENSE="GPL-2"
SLOT=${PV}
KEYWORDS="amd64 arm64 ppc64 x86"

RDEPEND="
	virtual/libelf
	!sys-kernel/gentoo-kernel-bin:${SLOT}
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"
BDEPEND="
	app-alternatives/bc
	app-alternatives/lex
	app-alternatives/yacc
	dev-util/pahole
	virtual/libelf
	verify-sig? ( >=sec-keys/openpgp-keys-kernel-20250702 )
"

KV_LOCALVERSION='-gentoo-dist-bin'
KV_FULL=${PV/_p/-p}${KV_LOCALVERSION}

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kernel.org.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc" \
			sha256 "${BASE_P}.tar.xz patch-${PATCH_PV}.xz"
		cd "${WORKDIR}" || die
	fi

	unpack "${BASE_P}.tar.xz" "patch-${PATCH_PV}.xz" "${PATCHSET}.tar.xz"
	local pkg_arch=${ARCH}
	[[ ${ARCH} == ppc64 ]] && pkg_arch=ppc64le
	tar -x -f "${DISTDIR}/${P}.tar.xz" "${P}/${pkg_arch}" || die
}

src_prepare() {
	local patch
	cd "${BASE_P}" || die
	eapply "${WORKDIR}/patch-${PATCH_PV}"
	eapply "${WORKDIR}/${PATCHSET}"

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

	local kernel_dir=( "${P}"/*/usr/src/"linux-${KV_FULL}" )

	mkdir modprep || die
	cp "${kernel_dir}/.config" modprep/ || die
	emake -C "${BASE_P}" "${makeargs[@]}" modules_prepare
}

src_install() {
	local rel_kernel_dir=/usr/src/linux-${KV_FULL}
	local pkg_dir=( "${P}"/* )
	local kernel_dir="${pkg_dir}/usr/src/linux-${KV_FULL}"
	local image="${kernel_dir}/$(dist-kernel_get_image_path)"
	local uki="${image%/*}/uki.efi"

	mv "${pkg_dir}"/lib "${ED}"/ || die
	cd "${kernel_dir}" || die
	insinto "${rel_kernel_dir}"
	doins System.map Module.symvers
	doins -r certs include scripts

	local kern_arch=$(tc-arch-kernel)
	insinto "${rel_kernel_dir}/arch/${kern_arch}"
	doins -r "arch/${kern_arch}/include"

	# Add the identifier
	echo "${CATEGORY}/${PF}:${SLOT}" > "${ED}${rel_kernel_dir}/dist-kernel" || die

	cd "${WORKDIR}/${BASE_P}" || die
	insinto "${rel_kernel_dir}"
	doins -r include

	# remove everything but Makefile* and Kconfig*
	find -type f '!' '(' -name 'Makefile*' -o -name 'Kconfig*' ')' \
		-delete || die
	find -type l -delete || die
	cp -p -R * "${ED}${rel_kernel_dir}/" || die

	# strip out-of-source build stuffs from modprep
	# and then copy built files
	cd "${WORKDIR}" || die
	find modprep -type f '(' \
			-name Makefile -o \
			-name '*.[ao]' -o \
			'(' -name '.*' -a -not -name '.config' ')' \
		')' -delete || die
	rm modprep/source || die
	cp -p -R modprep/. "${ED}${rel_kernel_dir}"/ || die
}

pkg_preinst() {
	dist-kernel_update_lib_symlinks
}

pkg_postinst() {
	dist-kernel_update_src_symlink "${EROOT}/usr/src/linux" "${KV_FULL}"
}
