# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KERNEL_VERSION=$(ver_cut 1-3)
KERNEL_TRUNK=$(ver_cut 1-2)
UEK_PATCH_VERSION=$(ver_cut 4-6)
UEK_VERSION="${KERNEL_VERSION}-${UEK_PATCH_VERSION}"

ETYPE="sources"

K_GENPATCHES_VER="106"
K_SECURITY_UNSUPPORTED="1"
CKV="${KERNEL_VERSION}_p${UEK_PATCH_VERSION}"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Unbreakable Enterprise Kernel (UEK) sources from Oracle"
HOMEPAGE="https://github.com/oracle/linux-uek"
SRC_URI="
	https://github.com/oracle/linux-uek/archive/refs/tags/v${UEK_VERSION}.tar.gz
		-> linux-uek-${UEK_VERSION}.tar.gz
	mirror://gentoo/genpatches-${KERNEL_TRUNK}-${K_GENPATCHES_VER}.base.tar.xz
	mirror://gentoo/genpatches-${KERNEL_TRUNK}-${K_GENPATCHES_VER}.experimental.tar.xz
	mirror://gentoo/genpatches-${KERNEL_TRUNK}-${K_GENPATCHES_VER}.extras.tar.xz
"
S="${WORKDIR}/linux-uek-${UEK_VERSION}"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="+gentoo experimental"

PATCHES=(
	"${FILESDIR}"/uek-sources-5.15.0.9.96.3-O3.patch
)

src_unpack() {
	default

	# remove all backup files
	find . -iname "*~" -print -exec rm {} \; 2>/dev/null

	unpack_set_extraversion
	unpack_fix_install_path

	env_setup_xmakeopts
}

src_prepare() {
	use gentoo && PATCHES+=(
		"${WORKDIR}"/1500_XATTR_USER_PREFIX.patch
		"${WORKDIR}"/1510_fs-enable-link-security-restrictions-by-default.patch
		"${WORKDIR}"/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch
		"${WORKDIR}"/2920_sign-file-patch-for-libressl.patch
		"${WORKDIR}"/3000_Support-printing-firmware-info.patch
		"${WORKDIR}"/4567_distro-Gentoo-Kconfig.patch
	)
	use experimental && PATCHES+=(
		"${WORKDIR}"/5010_enable-cpu-optimizations-universal.patch
	)
	default
}
