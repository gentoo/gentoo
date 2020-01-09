# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV}
AMD64_CONFIG_VER=5.4.7.arch1-1
AMD64_CONFIG_HASH=ff79453bc0451a9083bdaa02c3901372d61a9982
I686_CONFIG_VER=5.4.3-arch1
I686_CONFIG_HASH=076a52d43a08c4b3a3eacd1f2f9a855fb3b62f42

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
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
	!sys-kernel/vanilla-kernel-bin:${SLOT}"

pkg_pretend() {
	mount-boot_pkg_pretend

	ewarn "This is an experimental package.  The built kernel and/or initramfs"
	ewarn "may not work at all or fail with your bootloader configuration.  Please"
	ewarn "make sure to keep a backup kernel available before testing it."
}

src_prepare() {
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
