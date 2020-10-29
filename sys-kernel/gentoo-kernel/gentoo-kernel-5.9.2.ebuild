# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 1 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.9.2
CONFIG_HASH=94a4277f8827d1b2c911deabe56e7d929dc93146

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	amd64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
	arm64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-aarch64-fedora.config
			-> kernel-aarch64-fedora.config.${CONFIG_VER}
	)
	ppc64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-ppc64le-fedora.config
			-> kernel-ppc64le-fedora.config.${CONFIG_VER}
	)
	x86? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-i686-fedora.config
			-> kernel-i686-fedora.config.${CONFIG_VER}
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="debug"
REQUIRED_USE="arm? ( savedconfig )"

RDEPEND="
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"

pkg_pretend() {
	ewarn "Starting with 5.7.9, Distribution Kernels are switching from Arch"
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
			cp "${DISTDIR}/kernel-x86_64-fedora.config.${CONFIG_VER}" .config || die
			;;
		arm)
			return
			;;
		arm64)
			cp "${DISTDIR}/kernel-aarch64-fedora.config.${CONFIG_VER}" .config || die
			;;
		ppc64)
			cp "${DISTDIR}/kernel-ppc64le-fedora.config.${CONFIG_VER}" .config || die
			;;
		x86)
			cp "${DISTDIR}/kernel-i686-fedora.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	local config_tweaks=(
		# replace (none) with gentoo
		-e 's:^CONFIG_DEFAULT_HOSTNAME=:&"gentoo":'
		# we do support x32
		-e '/CONFIG_X86_X32/s:.*:CONFIG_X86_X32=y:'
		# disable signatures
		-e '/CONFIG_MODULE_SIG/d'
		-e '/CONFIG_SECURITY_LOCKDOWN/d'
		-e '/CONFIG_KEXEC_SIG/d'
		-e '/CONFIG_KEXEC_BZIMAGE_VERIFY_SIG/d'
		-e '/CONFIG_SYSTEM_EXTRA_CERTIFICATE/d'
		-e '/CONFIG_SIGNATURE/d'
		# remove massive array of LSMs
		-e 's/CONFIG_LSM=.*/CONFIG_LSM="yama"/'
		-e 's/CONFIG_DEFAULT_SECURITY_SELINUX=y/CONFIG_DEFAULT_SECURITY_DAC=y/'
		# nobody actually wants fips
		-e '/CONFIG_CRYPTO_FIPS/d'
		# these tests are really not necessary
		-e 's/.*CONFIG_CRYPTO_MANAGER_DISABLE_TESTS.*/CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y/'
		# probably not needed by anybody but developers
		-e '/CONFIG_CRYPTO_STATS/d'
		# 1000hz is excessive for laptops
		-e 's/CONFIG_HZ_1000=y/CONFIG_HZ_300=y/'
		# nobody is using this kernel on insane super computers
		-e 's/CONFIG_NR_CPUS=.*/CONFIG_NR_CPUS=512/'
		# we're not actually producing live patches for folks
		-e 's/CONFIG_LIVEPATCH=y/CONFIG_LIVEPATCH=n/'
		# this slows down networking in general
		-e 's/CONFIG_IP_FIB_TRIE_STATS=y/CONFIG_IP_FIB_TRIE_STATS=n/'
		# include font for normal and hidpi screens
		-e 's/.*CONFIG_FONTS.*/CONFIG_FONTS=y\nCONFIG_FONT_8x16=y\nCONFIG_FONT_TER16x32=y/'
		# we don't need to actually install system headers from this ebuild
		-e '/CONFIG_HEADERS_INSTALL/d'
		# enable /proc/config.gz, used by linux-info.eclass
		-e '/CONFIG_IKCONFIG/s:.*:CONFIG_IKCONFIG=y\nCONFIG_IKCONFIG_PROC=y:'
	)
	use debug || config_tweaks+=(
		-e '/CONFIG_DEBUG_INFO/d'
		-e '/CONFIG_DEBUG_RODATA_TEST/d'
		-e '/CONFIG_DEBUG_VM/d'
		-e '/CONFIG_DEBUG_SHIRQ/d'
		-e '/CONFIG_DEBUG_LIST/d'
		-e '/CONFIG_BUG_ON_DATA_CORRUPTION/d'
		-e '/CONFIG_TORTURE_TEST/d'
		-e '/CONFIG_BOOTTIME_TRACING/d'
		-e '/CONFIG_RING_BUFFER_BENCHMARK/d'
		-e '/CONFIG_X86_DECODER_SELFTEST/d'
		-e '/CONFIG_KGDB/d'
	)
	sed -i "${config_tweaks[@]}" .config || die
}
