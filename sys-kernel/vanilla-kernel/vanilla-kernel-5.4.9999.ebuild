# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 kernel-build

# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.4.21
CONFIG_HASH=2809b7faa6a8cb232cd825096c146b7bdc1e08ea
GENTOO_CONFIG_VER=g1

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+="
	https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	amd64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-x86_64.config
			-> kernel-x86_64.config.${CONFIG_VER}
	)
	arm64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-aarch64.config
			-> kernel-aarch64.config.${CONFIG_VER}
	)
	ppc64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-ppc64le.config
			-> kernel-ppc64le.config.${CONFIG_VER}
	)
	x86? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-i686.config
			-> kernel-i686.config.${CONFIG_VER}
	)
"

EGIT_REPO_URI=(
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/
	https://github.com/gregkh/linux/
)
EGIT_BRANCH="linux-${PV/.9999/.y}"

LICENSE="GPL-2"
KEYWORDS=""
IUSE="debug"
REQUIRED_USE="arm? ( savedconfig )"

BDEPEND="
	debug? ( dev-util/pahole )
"
PDEPEND="
	>=virtual/dist-kernel-$(ver_cut 1-2)
"

src_unpack() {
	git-r3_src_unpack
	default
}

src_prepare() {
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/kernel-x86_64.config.${CONFIG_VER}" .config || die
			;;
		arm64)
			cp "${DISTDIR}/kernel-aarch64.config.${CONFIG_VER}" .config || die
			;;
		ppc)
			# assume powermac/powerbook defconfig
			# we still package.use.force savedconfig
			cp "${WORKDIR}/${MY_P}/arch/powerpc/configs/pmac32_defconfig" .config || die
			;;
		ppc64)
			cp "${DISTDIR}/kernel-ppc64le.config.${CONFIG_VER}" .config || die
			;;
		x86)
			cp "${DISTDIR}/kernel-i686.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	echo 'CONFIG_LOCALVERSION="-dist"' > "${T}"/version.config || die
	local merge_configs=(
		"${T}"/version.config
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/base.config
	)
	use debug || merge_configs+=(
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/no-debug.config
	)
	[[ ${ARCH} == x86 ]] && merge_configs+=(
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/32-bit.config
	)

	kernel-build_merge_configs "${merge_configs[@]}"
}
