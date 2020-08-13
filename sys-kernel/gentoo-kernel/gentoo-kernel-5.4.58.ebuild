# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 1 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.4.21
CONFIG_HASH=2809b7faa6a8cb232cd825096c146b7bdc1e08ea

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~alicef/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~alicef/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	amd64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-x86_64.config
			-> kernel-x86_64.config.${CONFIG_VER}
	)
	x86? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-i686.config
			-> kernel-i686.config.${CONFIG_VER}
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"

pkg_pretend() {
	ewarn "Starting with 5.4.52, Distribution Kernels are switching from Arch"
	ewarn "Linux configs to Fedora.  Please keep a backup kernel just in case."

	kernel-install_pkg_pretend
}

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/kernel-x86_64.config.${CONFIG_VER}" .config || die
			;;
		x86)
			cp "${DISTDIR}/kernel-i686.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local config_tweaks=(
		# shove arch under the carpet!
		-e 's:^CONFIG_DEFAULT_HOSTNAME=:&"gentoo":'
		# we do support x32
		-e '/CONFIG_X86_X32/s:.*:CONFIG_X86_X32=y:'
		# disable signatures
		-e '/CONFIG_MODULE_SIG/d'
		-e '/CONFIG_SECURITY_LOCKDOWN/d'
	)
	use debug || config_tweaks+=(
		-e '/CONFIG_DEBUG_INFO/d'
	)
	[[ ${ARCH} == x86 ]] && config_tweaks+=(
		# fix autoenabling 64bit
		-e '2i\
# CONFIG_64BIT is not set'
	)
	sed -i "${config_tweaks[@]}" .config || die
}
