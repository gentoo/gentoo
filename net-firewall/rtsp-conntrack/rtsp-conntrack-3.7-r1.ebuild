# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

DESCRIPTION="RTSP conntrack module for Netfilter"
HOMEPAGE="http://mike.it-loops.com/rtsp"
SRC_URI="http://mike.it-loops.com/rtsp/rtsp-module-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/rtsp"

PATCHES=( "${FILESDIR}/${P}-linux-4.18.patch" )

BUILD_TARGETS="all"
MODULE_NAMES="
	nf_conntrack_rtsp(net/netfilter::)
	nf_nat_rtsp(net/ipv4/netfilter::)"
MODULESD_NF_CONNTRACK_RTSP_DOCS="README.rst"

CONFIG_CHECK="NF_CONNTRACK"
WARNING_NF_CONNTRACK="You must enable NF_CONNTRACK in your kernel, otherwise ${PN} would not work"

BUILD_PARAMS="KERNELDIR=${KERNEL_DIR} V=1"
