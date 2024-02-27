# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_IUSE_GENERIC_UKI=1
KERNEL_IUSE_MODULES_SIGN=1

inherit kernel-build toolchain-funcs

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 4 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
# forked to https://github.com/projg2/fedora-kernel-config-for-gentoo
CONFIG_VER=6.7.3-gentoo
GENTOO_CONFIG_VER=g11

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="
	https://wiki.gentoo.org/wiki/Project:Distribution_Kernel
	https://www.kernel.org/
"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
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

RDEPEND="
	!sys-kernel/gentoo-kernel-bin:${SLOT}
"
BDEPEND="
	debug? ( dev-util/pahole )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
	usr/src/linux-.*/arch/powerpc/kernel/vdso.*/vdso.*.so.dbg
"

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	local biendian=false

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/kernel-x86_64-fedora.config.${CONFIG_VER}" .config || die
			;;
		arm)
			return
			;;
		arm64)
			cp "${DISTDIR}/kernel-aarch64-fedora.config.${CONFIG_VER}" .config || die
			biendian=true
			;;
		hppa)
			return
			;;
		loong)
			return
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
		riscv)
			return
			;;
		sparc)
			return
			;;
		x86)
			cp "${DISTDIR}/kernel-i686-fedora.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local myversion="-gentoo-dist"
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
