# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils flag-o-matic linux-info linux-mod user versionator udev

PV_MAJOR=$(get_major_version)
PV_MINOR=$(get_version_component_range 2)

DESCRIPTION="VMware kernel modules"
HOMEPAGE="http://www.vmware.com/"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pax_kernel"

RDEPEND=""
DEPEND="${RDEPEND}
	|| ( =app-emulation/vmware-player-5.0.${PV_MINOR}*
	=app-emulation/vmware-workstation-9.0.${PV_MINOR}* )"

S=${WORKDIR}

pkg_setup() {
	CONFIG_CHECK="~HIGH_RES_TIMERS"
	if kernel_is ge 2 6 37 && kernel_is lt 2 6 39; then
		CONFIG_CHECK="${CONFIG_CHECK} BKL"
	fi

	linux-info_pkg_setup

	linux-mod_pkg_setup

	VMWARE_GROUP=${VMWARE_GROUP:-vmware}

	VMWARE_MODULE_LIST="vmblock vmci vmmon vmnet vsock"
	VMWARE_MOD_DIR="${PN}-${PVR}"

	BUILD_TARGETS="auto-build KERNEL_DIR=${KERNEL_DIR} KBUILD_OUTPUT=${KV_OUT_DIR}"

	enewgroup "${VMWARE_GROUP}"
	filter-flags -mfpmath=sse

	for mod in ${VMWARE_MODULE_LIST}; do
		MODULE_NAMES="${MODULE_NAMES} ${mod}(misc:${S}/${mod}-only)"
	done
}

src_unpack() {
	cd "${S}"
	for mod in ${VMWARE_MODULE_LIST}; do
		tar -xf /opt/vmware/lib/vmware/modules/source/${mod}.tar
	done
}

src_prepare() {
	epatch "${FILESDIR}/${PV_MAJOR}-makefile-kernel-dir.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-makefile-include.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-netdevice.patch"
	use pax_kernel && epatch "${FILESDIR}/${PV_MAJOR}-hardened.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-apic.patch"
	kernel_is ge 3 7 0 && epatch "${FILESDIR}/${PV_MAJOR}-putname.patch"

	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-00-userns.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-01-create_proc_entry.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-02-getname.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-03-deprecated.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-04-unused-typedef.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-05-dentry.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-06-inode.patch"

	# fixes a memcpy/memcmp bug in the hub code
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-07-hub.patch"

	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.11-00-readdir.patch"
	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.11-01-filldir.patch"
	kernel_is ge 3 13 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.13-00-vmnet.patch"
	kernel_is ge 3 15 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.15-00-readlink.patch"
	kernel_is ge 3 15 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.15-01-vsock.patch"
	kernel_is ge 3 17 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.17-00-netdev.patch"

	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-00-vmnet-warning.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-01-vmblock-path.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-02-vmci.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-03-vmnet.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-04-vsock.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-05-vsock.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-06-vmci_qpair.patch"

	# Allow user patches so they can support RC kernels and whatever else
	epatch_user
}

src_install() {
	linux-mod_src_install
	local udevrules="${T}/60-vmware.rules"
	cat > "${udevrules}" <<-EOF
		KERNEL=="vmci",  GROUP="vmware", MODE="660"
		KERNEL=="vmmon", GROUP="vmware", MODE="660"
		KERNEL=="vsock", GROUP="vmware", MODE="660"
	EOF
	udev_dorules "${udevrules}"
}
