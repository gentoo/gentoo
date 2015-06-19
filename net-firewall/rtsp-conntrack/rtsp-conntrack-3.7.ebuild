# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/rtsp-conntrack/rtsp-conntrack-3.7.ebuild,v 1.3 2013/10/17 07:28:00 pinkbyte Exp $

EAPI=5
inherit eutils linux-mod versionator

DESCRIPTION="RTSP conntrack module for Netfilter"
HOMEPAGE="http://mike.it-loops.com/rtsp"
SRC_URI="http://mike.it-loops.com/rtsp/rtsp-module-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/rtsp"

BUILD_TARGETS="all"
MODULE_NAMES="
	nf_conntrack_rtsp(net/netfilter::)
	nf_nat_rtsp(net/ipv4/netfilter::)"
MODULESD_NF_CONNTRACK_RTSP_DOCS="README.rst"

CONFIG_CHECK="NF_CONNTRACK"
WARNING_NF_CONNTRACK="You must enable NF_CONNTRACK in your kernel, otherwise ${PN} would not work"

BUILD_PARAMS="KERNELDIR=${KERNEL_DIR} V=1"

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is -lt $(get_version_components) && die "This version of ${PN} would not work on kernels <= ${PV}"
}

src_prepare() {
	epatch_user
}
