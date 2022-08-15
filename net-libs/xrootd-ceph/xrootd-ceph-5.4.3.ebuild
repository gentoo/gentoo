# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="xrootd OSS plug-in for interfacing with Ceph storage platform"
HOMEPAGE="https://xrootd.slac.stanford.edu/"
SRC_URI="https://github.com/xrootd/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="~net-libs/xrootd-${PV}
	sys-cluster/ceph"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/cppunit )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.0_no-werror.patch
)

# xrootd plugins are not intended to be linked with,
# they are to be loaded at runtime by xrootd,
# see https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrdCeph.*-$(ver_cut 1)\.so
	/usr/lib.*/libXrdCephTests\.so"

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}
