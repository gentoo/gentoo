# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils linux-info

DESCRIPTION="A daemon that handles the userspace side of the LIO TCM-User backstore"
HOMEPAGE="http://www.open-iscsi.com/"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PVR}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="glfs +qcow rbd +systemd +zbc"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libnl:3
	sys-libs/zlib
	sys-apps/kmod
	rbd? ( sys-cluster/ceph )
	glfs? ( <sys-cluster/glusterfs-6.0 )
	systemd? ( sys-apps/systemd )"
BDEPEND="
	rbd? ( sys-cluster/ceph )
	glfs? ( <sys-cluster/glusterfs-6.0 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PF}"

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is -lt 2 6 16; then
		die "Sorry, your kernel must be 2.6.16-rc5 or newer!"
	fi

	CONFIG_CHECK_MODULES="TCM_USER2"
	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_module ${module} || \
				ewarn "${module} needs to be built as module (builtin doesn't work)"
		done
	fi
}

src_configure() {
	local mycmakeargs

	mycmakeargs=(
		-Dwith-rbd=$(usex rbd)
		-Dwith-glfs=$(usex glfs)
		-Dwith-zbc=$(usex zbc)
		-Dwith-qcow=$(usex qcow)
		-DSUPPORT_SYSTEMD=$(usex systemd)
		-DCMAKE_INSTALL_PREFIX=/usr
	)

	cmake-utils_src_configure
}
