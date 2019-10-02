# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit linux-mod

DESCRIPTION="RTSP conntrack module for Netfilter"
HOMEPAGE="http://mike.it-loops.com/rtsp"
SRC_URI="https://github.com/maru-sama/rtsp-linux/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/rtsp-linux-${PV}"

PATCHES=( "${FILESDIR}/${P}-linux-5.3.patch" )

BUILD_TARGETS="all"
MODULE_NAMES="
	nf_conntrack_rtsp(net/netfilter::)
	nf_nat_rtsp(net/ipv4/netfilter::)"
MODULESD_NF_CONNTRACK_RTSP_DOCS="README.rst"

CONFIG_CHECK="NF_CONNTRACK"
WARNING_NF_CONNTRACK="You must enable NF_CONNTRACK in your kernel, otherwise ${PN} would not work"

BUILD_PARAMS="KERNELDIR=${KERNEL_DIR} V=1"
