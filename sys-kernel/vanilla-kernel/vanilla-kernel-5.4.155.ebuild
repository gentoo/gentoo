# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build verify-sig

MY_P=linux-${PV}
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.4.21
CONFIG_HASH=2809b7faa6a8cb232cd825096c146b7bdc1e08ea
GENTOO_CONFIG_VER=5.4.114

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/v${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	verify-sig? (
		https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.sign
	)
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
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="debug"

RDEPEND="
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/pahole )
	verify-sig? ( app-crypt/openpgp-keys-kernel )"
PDEPEND="
	>=virtual/dist-kernel-${PV}"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/kernel.org.asc

src_unpack() {
	if use verify-sig; then
		einfo "Unpacking linux-${PV}.tar.xz ..."
		verify-sig_verify_detached - "${DISTDIR}"/linux-${PV}.tar.sign \
			< <(xz -cd "${DISTDIR}"/linux-${PV}.tar.xz | tee >(tar -x))
		assert "Unpack failed"
		unpack "gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz"
	else
		default
	fi
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
