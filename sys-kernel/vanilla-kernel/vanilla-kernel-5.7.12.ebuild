# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV}
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.7.8
CONFIG_HASH=14d239184a721485a823f30f5aede1c6190558ad

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	amd64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
	x86? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-i686-fedora.config
			-> kernel-i686-fedora.config.${CONFIG_VER}
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="debug"
REQUIRED_USE="
	arm? ( savedconfig )
	arm64? ( savedconfig )"

RDEPEND="
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"

pkg_pretend() {
	ewarn "Starting with 5.7.9, Distribution Kernels are switching from Arch"
	ewarn "Linux configs to Fedora.  Please keep a backup kernel just in case."

	kernel-install_pkg_pretend
}

src_prepare() {
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/kernel-x86_64-fedora.config.${CONFIG_VER}" .config || die
			;;
		x86)
			cp "${DISTDIR}/kernel-i686-fedora.config.${CONFIG_VER}" .config || die
			;;
		arm|arm64)
			return
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
	sed -i "${config_tweaks[@]}" .config || die
}
