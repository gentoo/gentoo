# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic linux-info linux-mod user versionator udev

PV_MAJOR=$(get_major_version)
PV_MINOR=$(get_version_component_range 2-3)

DESCRIPTION="VMware kernel modules"
HOMEPAGE="http://www.vmware.com/"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pax_kernel +vmci +vsock"
REQUIRED_USE="!vsock? ( !vmci )"

RDEPEND=""
DEPEND="${RDEPEND}
	|| ( =app-emulation/vmware-player-12.${PV_MINOR}*
	=app-emulation/vmware-workstation-12.${PV_MINOR}* )"

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

	filter-flags -mfpmath=sse -mavx -mpclmul -maes
	append-cflags -mno-sse  # Found a problem similar to bug #492964

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
	kernel_is ge 3 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.10-03-inline.patch"
	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.11-00-readdir.patch"
	kernel_is ge 3 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.11-01-filldir.patch"
	kernel_is ge 3 15 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.15-00-vsock.patch"
	kernel_is ge 3 18 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.18-00-version-redefined.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-00-compat-namei.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-02-vmblock-path.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-04-iovec.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-05-vmci_qpair.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-06-vsock.patch"
	kernel_is ge 3 19 0 && epatch "${FILESDIR}/${PV_MAJOR}-3.19-07-vsock.patch"
	kernel_is ge 4 1 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.01-00-vsock.patch"
	kernel_is ge 4 2 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.02-00-nd_set_link.patch"
	kernel_is ge 4 2 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.02-01-sk_alloc.patch"
	kernel_is ge 4 3 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.03-00-vmci-misc_deregister.patch"
	kernel_is ge 4 5 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.05-00-vmblock-follow_link.patch"
	kernel_is ge 4 6 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.06-00-user-pages.patch"
	kernel_is ge 4 7 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.07-01-readlink_copy.patch"
	kernel_is ge 4 8 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.08-00-nr_anon_mapped.patch"
	kernel_is ge 4 9 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.09-00-user-pages.patch"
	kernel_is ge 4 10 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.10-00-generic_readlink.patch"
	kernel_is ge 4 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.11-00-missing-headers.patch"
	kernel_is ge 4 11 0 && epatch "${FILESDIR}/${PV_MAJOR}-4.11-01-vsock-lockdep.patch"

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

	if ! use vmci ; then
		dodir /etc/modprobe.d/

		cat > "${D}"/etc/modprobe.d/vmware.conf <<-EOF
			# Support for vmware vmci in kernel module
			alias vmci	vmw_vmci
		EOF

		export installed_modprobe_conf=1
	fi
	if ! use vsock ; then
		dodir /etc/modprobe.d/
		cat >> "${D}"/etc/modprobe.d/vmware.conf <<-EOF
			# Support for vmware vsock in kernel module
			alias vsock	vmw_vsock_vmci_transport
		EOF

		export installed_modprobe_conf=1
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if [ "${installed_modprobe_conf}"x == "x"  ] ; then
		if [ -f "${ROOT}/etc/modprobe.d/vmware.conf" ] ; then
			ewarn "Please check the /etc/modprobe.d/vmware.conf file and"
			ewarn "possible conflicts when using vmci and/or vsock modules built"
			ewarn "out of kernel"
		fi
	fi
}
