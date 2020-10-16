# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="xrootd OSS plug-in for interfacing with Ceph storage platform"
HOMEPAGE="https://xrootd.slac.stanford.edu/"
SRC_URI="https://github.com/xrootd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

DEPEND="net-libs/xrootd
	!<net-libs/xrootd-4.10.0[rbd]
	sys-cluster/ceph"
RDEPEND="${DEPEND}"

# xrootd plugins are not intended to be linked with,
# they are to be loaded at runtime by xrootd,
# see https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrd.*-$(ver_cut 1).so"
