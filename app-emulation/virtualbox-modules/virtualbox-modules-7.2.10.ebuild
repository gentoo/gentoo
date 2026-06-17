# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: the tarball here is just the kernel modules split out of the sources
#      using the upstream provided export_modules.sh
#      https://distfiles.gentoo.org/pub/dev/ceamac@gentoo.org/app-emulation/virtualbox-modules/make-modules-from-source

EAPI=8

inherit eapi9-ver linux-mod-r1

MY_P="vbox-host-kernel-module-src-${PV^^}"
DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://distfiles.gentoo.org/pub/dev/ceamac@gentoo.org/${CATEGORY}/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

CONFIG_CHECK="~!SPINLOCK JUMP_LABEL ~PREEMPT_NOTIFIERS ~KPROBES"
KPROBES_ERROR="CONFIG_KPROBES is required for kernel 6.16+; modules fail to build with kernel 6.19+"

src_compile() {
	local modlist=( {vboxdrv,vboxnetflt,vboxnetadp}=misc )
	local modargs=( KERN_DIR="${KV_OUT_DIR}" KERN_VER="${KV_FULL}" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	insinto /usr/lib/modules-load.d/
	newins "${FILESDIR}"/virtualbox.conf-r1 virtualbox.conf
}

pkg_postinst() {
	if ver_replacing -lt "7.2.10"; then
		ewarn 'Starting with 7.2.10, using the `kvm.enable_virt_at_load=0` kernel parameter'
		ewarn ' prevents the virtual machines from starting.'
		ewarn 'The file `/etc/modprobe.d/virtualbox.conf` should be removed'
		ewarn ' and the kvm related modules should be reloaded.'
		ewarn ''
	fi
}
