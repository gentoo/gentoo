# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# XXX: the tarball here is just the kernel modules split out of the binary
#      package that comes from VirtualBox-*.run
# XXX: update: now it is split from virtualbox-*-Debian~bullseye_amd64.deb

EAPI=8

inherit linux-mod-r1

MY_P="vbox-guest-kernel-module-src-${PV}"
DESCRIPTION="Kernel Modules for Virtualbox Guest Additions"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://dev.gentoo.org/~ceamac/${CATEGORY}/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.36-log-use-c99.patch
	"${FILESDIR}"/${PN}-7.1.8-kernel-6.15.patch
)

CONFIG_CHECK="~DRM_TTM ~DRM_VMWGFX"
WARNING_DRM_TTM="DRM_TTM is needed for running the vboxvideo driver."
WARNING_DRM_VMWGFX="DRM_VMWGFX is the recommended driver for VMSVGA."

src_compile() {
	local modlist=( {vboxguest,vboxsf}=misc )
	local modargs=( KERN_DIR="${KV_OUT_DIR}" KERN_VER="${KV_FULL}" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /etc/modprobe.d # 485996
	newins - vboxsf.conf <<-EOF
		# modprobe.d configuration file for VBOXSF

		# Internal Aliases - Do not edit
		# ------------------------------
		alias fs-vboxsf vboxsf
	EOF
}
