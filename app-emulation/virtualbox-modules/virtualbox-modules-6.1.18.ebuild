# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from virtualbox-bin

EAPI=7

inherit linux-mod toolchain-funcs

MY_P="vbox-kernel-module-src-${PV}"
DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://dev.gentoo.org/~polynomial-c/virtualbox/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/$(ver_cut 1-2)"
[[ "${PV}" == *_beta* ]] || [[ "${PV}" == *_rc* ]] || \
KEYWORDS="amd64"
IUSE="pax_kernel"

RDEPEND="!=app-emulation/virtualbox-9999"

S="${WORKDIR}"

BUILD_TARGETS="all"
MODULE_NAMES="vboxdrv(misc:${S}) vboxnetflt(misc:${S}) vboxnetadp(misc:${S})"
MODULESD_VBOXDRV_ENABLED="yes"
MODULESD_VBOXNETADP_ENABLED="no"
MODULESD_VBOXNETFLT_ENABLED="no"

PATCHES=(
	"${FILESDIR}/${P}-linux-5.11.patch" #762994
	"${FILESDIR}/${P}-binutils-2.36.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="CC=$(tc-getBUILD_CC) KERN_DIR=${KV_DIR} KERN_VER=${KV_FULL} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
}

src_prepare() {
	if use pax_kernel && kernel_is -ge 3 0 0 ; then
		eapply -p0 "${FILESDIR}"/${PN}-5.2.8-pax-const.patch
	fi

	default
}

src_install() {
	linux-mod_src_install
	insinto /usr/lib/modules-load.d/
	newins "${FILESDIR}"/virtualbox.conf-r1 virtualbox.conf
}

pkg_postinst() {
	# Remove vboxpci.ko from current running kernel
	find /lib/modules/${KV_FULL}/misc -type f -name "vboxpci.ko" -delete
	linux-mod_pkg_postinst
}
