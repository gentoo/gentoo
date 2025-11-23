# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MODULES_OPTIONAL_IUSE=+modules
inherit autotools git-r3 linux-mod-r1 toolchain-funcs udev

DESCRIPTION="High-Performance Intra-Node MPI Communication"
HOMEPAGE="https://knem.gitlabpages.inria.fr/"
EGIT_REPO_URI="https://gitlab.inria.fr/knem/knem.git"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="debug modules"

DEPEND="
		sys-apps/hwloc:=
		virtual/linux-sources"
RDEPEND="
		sys-apps/hwloc:=
		sys-apps/kmod[tools]"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="DMA_ENGINE"
	check_extra_config
	linux-mod-r1_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	sed 's:driver/linux::g' -i Makefile.am
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
	local modlist=( knem=misc:"${S}/driver/linux" )
	default
	linux-mod-r1_src_compile || die "failed to build driver"
}

src_install() {
	default
	linux-mod-r1_src_install

	# Drop funny unneeded stuff
	rm "${ED}/usr/sbin/knem_local_install" || die
	rmdir "${ED}/usr/sbin" || die
	# install udev rules
	udev_dorules "${FILESDIR}/45-knem.rules"
	rm "${ED}/etc/10-knem.rules" || die
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	udev_reload
}

pkg_postrm() {
	udev_reload
}
