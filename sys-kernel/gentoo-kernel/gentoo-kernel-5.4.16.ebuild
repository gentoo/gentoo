# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-${PV##*.}
# https://git.archlinux.org/svntogit/packages.git/log/trunk/config?h=packages/linux
AMD64_CONFIG_VER=5.4.13.arch1
AMD64_CONFIG_HASH=9eed969590614a38d370a9fe04a4f5d38ba5e06e
# https://git.archlinux32.org/packages/log/core/linux/config.i686
I686_CONFIG_VER=5.4.13-arch1
I686_CONFIG_HASH=95f890a9f9131e7a0e01a4f3e9c5ee423756a233

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	amd64? (
		https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux&id=${AMD64_CONFIG_HASH}
			-> linux-${AMD64_CONFIG_VER}.amd64.config
	)
	x86? (
		https://git.archlinux32.org/packages/plain/core/linux/config.i686?id=${I686_CONFIG_HASH}
			-> linux-${I686_CONFIG_VER}.i686.config
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}"/linux-${AMD64_CONFIG_VER}.amd64.config .config || die
			;;
		x86)
			cp "${DISTDIR}"/linux-${I686_CONFIG_VER}.i686.config .config || die
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
		# disable compression to allow stripping
		-e '/CONFIG_MODULE_COMPRESS/d'
		# disable gcc plugins to unbreak distcc
		-e '/CONFIG_GCC_PLUGIN_STRUCTLEAK/d'
	)
	sed -i "${config_tweaks[@]}" .config || die
}
