# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1
KERNEL_IUSE_MODULES_SIGN=1

inherit kernel-build toolchain-funcs verify-sig

MY_P=linux-${PV%.*}
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
# forked to https://github.com/projg2/fedora-kernel-config-for-gentoo
CONFIG_VER=6.6.12-gentoo
GENTOO_CONFIG_VER=g16
SHA256SUM_DATE=20250717

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/patch-${PV}.xz
	https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	verify-sig? (
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/sha256sums.asc
			-> linux-$(ver_cut 1).x-sha256sums-${SHA256SUM_DATE}.asc
	)
	amd64? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
	arm64? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-aarch64-fedora.config
			-> kernel-aarch64-fedora.config.${CONFIG_VER}
	)
	ppc64? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-ppc64le-fedora.config
			-> kernel-ppc64le-fedora.config.${CONFIG_VER}
	)
	x86? (
		https://raw.githubusercontent.com/projg2/fedora-kernel-config-for-gentoo/${CONFIG_VER}/kernel-i686-fedora.config
			-> kernel-i686-fedora.config.${CONFIG_VER}
	)
"
S=${WORKDIR}/${MY_P}

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug hardened"
REQUIRED_USE="
	arm? ( savedconfig )
	hppa? ( savedconfig )
	riscv? ( savedconfig )
	sparc? ( savedconfig )
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
			sha256 "${MY_P}.tar.xz patch-${PV}.xz"
		cd "${WORKDIR}" || die
	fi

	default
}

src_prepare() {
	eapply "${WORKDIR}/patch-${PV}"
	default

	local biendian=false

	# prepare the default config
	case ${ARCH} in
		arm | hppa | loong | riscv | sparc)
			> .config || die
		;;
		amd64)
			cp "${DISTDIR}/kernel-x86_64-fedora.config.${CONFIG_VER}" .config || die
			;;
		arm64)
			cp "${DISTDIR}/kernel-aarch64-fedora.config.${CONFIG_VER}" .config || die
			biendian=true
			;;
		ppc)
			# assume powermac/powerbook defconfig
			# we still package.use.force savedconfig
			cp "${WORKDIR}/${MY_P}/arch/powerpc/configs/pmac32_defconfig" .config || die
			;;
		ppc64)
			cp "${DISTDIR}/kernel-ppc64le-fedora.config.${CONFIG_VER}" .config || die
			biendian=true
			;;
		x86)
			cp "${DISTDIR}/kernel-i686-fedora.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local myversion="-dist"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
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

	use secureboot && merge_configs+=( "${dist_conf_path}/secureboot.config" )

	kernel-build_merge_configs "${merge_configs[@]}"
}
