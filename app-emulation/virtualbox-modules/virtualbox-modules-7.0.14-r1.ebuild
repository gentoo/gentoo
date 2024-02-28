# Copyright 2022-2024 Gentoo Authors
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
	"${FILESDIR}"/${P}-kernel-6.6-warning.patch
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
}
