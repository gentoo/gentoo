# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic linux-info linux-mod user versionator udev

PV_MAJOR=$(get_major_version)
PV_MINOR=$(get_version_component_range 2)

DESCRIPTION="VMware kernel modules"
HOMEPAGE="http://www.vmware.com/"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="pax_kernel +vmci +vsock"

RDEPEND=""
DEPEND="${RDEPEND}
	|| ( =app-emulation/vmware-player-7.1.${PV_MINOR}*
	=app-emulation/vmware-workstation-11.1.${PV_MINOR}* )"

S=${WORKDIR}

pkg_setup() {
	CONFIG_CHECK="~HIGH_RES_TIMERS"
	if kernel_is ge 2 6 37 && kernel_is lt 2 6 39; then
		CONFIG_CHECK="${CONFIG_CHECK} BKL"
	fi
	if use vmci ; then
		CONFIG_CHECK="${CONFIG_CHECK} !VMWARE_VMCI"
	else
		CONFIG_CHECK="${CONFIG_CHECK} VMWARE_VMCI"
	fi
	if use vsock ; then
		CONFIG_CHECK="${CONFIG_CHECK} !VMWARE_VMCI_VSOCKETS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} VMWARE_VMCI_VSOCKETS"
	fi

	linux-info_pkg_setup

	linux-mod_pkg_setup

	VMWARE_GROUP=${VMWARE_GROUP:-vmware}

	VMWARE_MODULE_LIST_ALL="vmblock vmmon vmnet vmci vsock"
	VMWARE_MODULE_LIST="vmblock vmmon vmnet"
	use vmci && VMWARE_MODULE_LIST="${VMWARE_MODULE_LIST} vmci"
	use vsock && VMWARE_MODULE_LIST="${VMWARE_MODULE_LIST} vsock"

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
	for mod in ${VMWARE_MODULE_LIST_ALL}; do
		tar -xf /opt/vmware/lib/vmware/modules/source/${mod}.tar
	done
}

src_prepare() {
	epatch "${FILESDIR}/${PV_MAJOR}-makefile-kernel-dir.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-makefile-include.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-netdevice.patch"
	use pax_kernel && epatch "${FILESDIR}/${PV_MAJOR}-hardened.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-apic.patch"

	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-00-dentry.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-01-inode.patch"
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-02-control.patch"
	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-03-inline.patch"
	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.11-00-readdir.patch"
	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.11-01-filldir.patch"
	kernel_is ge 3 15 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.15-00-vsock.patch"
	kernel_is ge 3 18 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.18-00-version-redefined.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-00-compat-namei.patch"
	#kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-01-dentry.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-02-vmblock-path.patch"
	#kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-03-iovec.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-04-iovec.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-05-vmci_qpair.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-06-vsock.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-07-vsock.patch"
	kernel_is ge 4 2 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.2-00-inode_op.patch"
	kernel_is ge 4 2 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.2-01-vmci_vmalloc.patch"
	kernel_is ge 4 2 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.2-02-vsock.patch"
	kernel_is ge 4 2 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.2-03-vsock.patch"
	kernel_is ge 4 3 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.3-00-misc_deregister.patch"
	kernel_is ge 4 5 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.5-00-get_link.patch"

	# Allow user patches so they can support RC kernels and whatever else
	epatch_user
}

src_install() {
	linux-mod_src_install
	local udevrules="${T}/60-vmware.rules"
	cat > "${udevrules}" <<-EOF
		KERNEL=="vmci",  GROUP="vmware", MODE="660"
		KERNEL=="vmw_vmci",  GROUP="vmware", MODE="660"
		KERNEL=="vmmon", GROUP="vmware", MODE="660"
		KERNEL=="vsock", GROUP="vmware", MODE="660"
	EOF
	udev_dorules "${udevrules}"
}
