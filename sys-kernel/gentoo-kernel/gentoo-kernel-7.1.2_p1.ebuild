# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1

inherit kernel-build toolchain-funcs verify-sig

BASE_P=linux-${PV%.*}
PATCH_PV=${PV%_p*}
PATCHSET=linux-gentoo-patches-${PV}
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
# forked to git.gentoo.org:fork/fedora/kernel
CONFIG_VER=7.1.1-gentoo
GENTOO_CONFIG_P=gentoo-kernel-config-g19
SHA256SUM_DATE=20260627
# Debian kconfig commit from:
# https://salsa.debian.org/kernel-team/linux/-/tree/debian/latest/debian/
DEBIAN_COMMIT=19e11bd2f2609851c0ce81f3bd307eb9008521dd

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${BASE_P}.tar.xz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PATCH_PV}.xz
	https://distfiles.gentoo.org/pub/proj/dist-kernel/patchsets/$(ver_cut 1-2)/${PATCHSET}.tar.xz
	https://gitweb.gentoo.org/proj/dist-kernel/gentoo-kernel-config.git/snapshot/${GENTOO_CONFIG_P}.tar.bz2
	https://gitweb.gentoo.org/fork/fedora/kernel.git/snapshot/kernel-${CONFIG_VER}.tar.bz2
	https://salsa.debian.org/kernel-team/linux/-/archive/${DEBIAN_COMMIT}/linux-${DEBIAN_COMMIT}.tar.bz2
	verify-sig? (
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/sha256sums.asc
			-> linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc
	)
"
S=${WORKDIR}/${BASE_P}

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="debug hardened"
REQUIRED_USE="
	hppa? ( savedconfig )
	mips? ( savedconfig )
"

BDEPEND="
	debug? ( dev-util/pahole )
	verify-sig? ( >=sec-keys/openpgp-keys-kernel-20250702 )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
	usr/src/linux-.*/arch/powerpc/kernel/vdso.*/vdso.*.so.dbg
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/kernel.org.asc

src_unpack() {
	if use verify-sig; then
		cd "${DISTDIR}" || die
		verify-sig_verify_signed_checksums \
			"linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc" \
			sha256 "${BASE_P}.tar.xz patch-${PATCH_PV}.xz"
		cd "${WORKDIR}" || die
	fi

	default
}

src_prepare() {
	local patch
	eapply "${WORKDIR}/patch-${PATCH_PV}"
	eapply "${WORKDIR}/${PATCHSET}"

	default

	# add Gentoo patchset version
	local extraversion=${PV#${PATCH_PV}}
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${extraversion/_/-}:" Makefile || die

	local biendian=false

	# prepare the default config
	case ${ARCH} in
		hppa | mips)
			> .config || die
		;;
		alpha)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/alpha/config" \
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/alpha/config.alpha-smp"
			)
			;;
		amd64)
			cp "${WORKDIR}/kernel-${CONFIG_VER}/kernel-x86_64-fedora.config" .config || die
			;;
		arm)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/armhf/config" \
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/armhf/config.armmp-lpae"
			)
			;;
		arm64)
			cp "${WORKDIR}/kernel-${CONFIG_VER}/kernel-aarch64-fedora.config" .config || die
			biendian=true
			;;
		loong)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/loong64/config"
			)
			;;
		m68k)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/m68k/config"
			)
			;;
		ppc)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/powerpc/config.powerpc"
			)
			;;
		ppc64)
			cp "${WORKDIR}/kernel-${CONFIG_VER}/kernel-ppc64le-fedora.config" .config || die
			biendian=true
			;;
		riscv)
			cp "${WORKDIR}/kernel-${CONFIG_VER}/kernel-riscv64-fedora.config" .config || die
			;;
		s390)
			cp "${WORKDIR}/kernel-${CONFIG_VER}/kernel-s390x-fedora.config" .config || die
			;;
		sparc)
			cp "${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/config" .config || die
			merge_configs+=(
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/sparc64/config.sparc64" \
				"${WORKDIR}/linux-${DEBIAN_COMMIT}/debian/config/sparc64/config.sparc64-smp"
			)
			;;
		x86)
			cp "${WORKDIR}/kernel-${CONFIG_VER}/kernel-i686-fedora.config" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local myversion="-gentoo-dist"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/${GENTOO_CONFIG_P}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
		"${dist_conf_path}"/6.12+.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
	)
	if use hardened; then
		merge_configs+=( "${dist_conf_path}"/hardened-base.config )

		tc-is-gcc && merge_configs+=( "${dist_conf_path}"/hardened-gcc-plugins.config )

		if [[ -f "${dist_conf_path}/hardened-${ARCH}.config" ]]; then
			merge_configs+=( "${dist_conf_path}/hardened-${ARCH}.config" )
		fi
	fi

	# this covers ppc64 and aarch64_be only for now
	if [[ ${biendian} == true && $(tc-endian) == big ]]; then
		merge_configs+=( "${dist_conf_path}/big-endian.config" )
	fi

	use secureboot && merge_configs+=(
		"${dist_conf_path}/secureboot.config"
		"${dist_conf_path}/zboot.config"
	)

	kernel-build_merge_configs "${merge_configs[@]}"
}
