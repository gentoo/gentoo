# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="RTSP conntrack module for Netfilter"
HOMEPAGE="http://mike.it-loops.com/rtsp"
SRC_URI="https://github.com/maru-sama/rtsp-linux/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rtsp-linux-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

CONFIG_CHECK="NF_CONNTRACK"

src_compile() {
	local modlist=(
		nf_conntrack_rtsp=net/netfilter
		nf_nat_rtsp=net/ipv4/netfilter
	)
	local modargs=( KERNELDIR="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
