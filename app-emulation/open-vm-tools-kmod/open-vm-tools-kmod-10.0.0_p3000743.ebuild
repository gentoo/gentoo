# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils linux-mod udev

MY_PN=${PN%-kmod}
MY_P=${MY_PN}-${PV/_p/-}

DESCRIPTION="Opensourced tools for VMware guests"
HOMEPAGE="http://open-vm-tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	CONFIG_CHECK="~DRM_VMWGFX ~VMWARE_BALLOON ~VMWARE_PVSCSI ~VMXNET3"

	# See logic in configure.ac.
	local MODULES=

	if kernel_is -lt 3 3; then
		MODULES+=" vmxnet"
	fi

	if kernel_is -lt 4; then
		MODULES+=" vmhgfs"
	fi

	if kernel_is -lt 3 9; then
		MODULES+=" vmci vsock"
	else
		CONFIG_CHECK+=" ~VMWARE_VMCI ~VMWARE_VMCI_VSOCKETS"
	fi

	if kernel_is -lt 3; then
		MODULES+=" vmblock vmsync"
	else
		CONFIG_CHECK+=" ~FUSE_FS"
	fi

	local mod
	for mod in ${MODULES}; do
		MODULE_NAMES+=" ${mod}(ovt:modules/linux/${mod})"
	done

	linux-mod_pkg_setup
}

src_prepare() {
	epatch_user
}

src_configure() {
	BUILD_TARGETS="auto-build"
	export OVT_SOURCE_DIR="${S}"
	export LINUXINCLUDE="${KV_OUT_DIR}/include"
}

src_install() {
	linux-mod_src_install
	udev_dorules "${FILESDIR}/60-vmware.rules"
}
