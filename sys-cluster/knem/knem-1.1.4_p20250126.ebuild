# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_IUSE=+modules
inherit autotools dkms toolchain-funcs udev

DESCRIPTION="High-Performance Intra-Node MPI Communication"
HOMEPAGE="https://knem.gitlabpages.inria.fr/"
SRC_URI="https://dev.gentoo.org/~mpagano/dist/${PN}/${P}.tar.xz"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="debug"

DEPEND="
	sys-apps/hwloc:=
	virtual/linux-sources
"
RDEPEND="
	sys-apps/hwloc:=
	sys-apps/kmod[tools]
"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="DMA_ENGINE"
	check_extra_config
	linux-mod-r1_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	if ! use dkms; then
		sed 's:driver/linux::g' -i Makefile.am || die
	fi
	eautoreconf
	default
}

src_configure() {
	econf \
		--enable-hwloc \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release=${KV_FULL} \
		$(use_enable debug)
}

src_compile() {
	local modlist=( knem=misc:driver/linux )
	default
	if use dkms; then
		dkms_gentoofy_conf
	else
		linux-mod-r1_src_compile
	fi
}

src_install() {
	default
	dkms_src_install

	# Drop funny unneeded stuff
	rm "${ED}/usr/sbin/knem_local_install" || die
	rmdir "${ED}/usr/sbin" || die
	# install udev rules
	udev_dorules "${FILESDIR}/45-knem.rules"
	rm "${ED}/etc/10-knem.rules" || die
}

pkg_postinst() {
	dkms_pkg_postinst
	udev_reload
}

pkg_postrm() {
	udev_reload
}
