# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm linux-info udev

PV_BASE=${PV/_*}
PV_FULL=${PV/_p/-}

DESCRIPTION="XenServer Virtual Machine Tools"
HOMEPAGE="https://www.citrix.com/"
SRC_URI="http://updates.vmd.citrix.com/XenServer/${PV_BASE}/rhel4x/SRPMS/xe-guest-utilities-${PV_FULL}.src.rpm"
S="${WORKDIR}"

LICENSE="LGPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xenstore"

BDEPEND="app-arch/rpm2targz"
RDEPEND="
	!xenstore? ( app-emulation/xen-tools )
	xenstore? ( !app-emulation/xen-tools )
"

CONFIG_CHECK="~XEN_COMPAT_XENFS ~XENFS"
QA_PREBUILT="usr/bin/xenstore* usr/bin/xeninfo"

PATCHES=(
	"${FILESDIR}"/${PN}-6.2.0_p1120-Guest-Attributes.patch
	"${FILESDIR}"/${PN}-6.2.0_p1120-Linux-Distribution.patch
)

src_unpack() {
	rpm_src_unpack ${A}
	# Upstream includes xenstore-sources.tar.bz2
	# but it is NOT the complete source :-(
}

src_install() {
	newinitd "${FILESDIR}"/xe-daemon.initd xe-daemon
	dosbin xe-daemon
	dosbin xe-linux-distribution
	dosbin xe-update-guest-attrs

	udev_newrules xen-vcpu-hotplug.rules 10-xen-vcpu-hotplug.rules

	if use xenstore; then
		dobin usr/bin/xeninfo
		dobin usr/bin/xenstore
		dobin usr/bin/xenstore-*
	fi
}

pkg_postinst() {
	udev_reload

	if [ ! -e /etc/runlevels/boot/xe-daemon ]; then
		elog "To start the xe-daemon automatically by default"
		elog "you should add it to the boot runlevel :"
		elog "'rc-update add xe-daemon boot'"
		elog
	fi
}
