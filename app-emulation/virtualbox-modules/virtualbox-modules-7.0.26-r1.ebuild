# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from VirtualBox-*.run
# XXX: update: now it is split from virtualbox-*-Debian~bullseye_amd64.deb

EAPI=8

inherit linux-mod-r1

MY_P="vbox-kernel-module-src-${PV}"
DESCRIPTION="Kernel Modules for Virtualbox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

CONFIG_CHECK="~!SPINLOCK JUMP_LABEL"

PATCHES=(
	"${FILESDIR}"/${PN}-7.1.8-kernel-6.15.patch
)

src_compile() {
	local modlist=( {vboxdrv,vboxnetflt,vboxnetadp}=misc )
	local modargs=( KERN_DIR="${KV_OUT_DIR}" KERN_VER="${KV_FULL}" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	insinto /usr/lib/modules-load.d/
	newins "${FILESDIR}"/virtualbox.conf-r1 virtualbox.conf

	insinto /etc/modprobe.d # bug #945135
	newins - virtualbox.conf <<-EOF
			# modprobe.d configuration file for VBOXSF

			# Starting with kernel 6.12,
			#   KVM initializes virtualization on module loading by default.
			# This prevents VirtualBox VMs from starting.
			# See also:
			#   https://bugs.gentoo.org/945135
			#   https://www.virtualbox.org/wiki/Changelog-7.1
			# ------------------------------
			options kvm enable_virt_at_load=0
	EOF
}
