# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="xrootd OSS plug-in for interfacing with Ceph storage platform"
HOMEPAGE="https://xrootd.slac.stanford.edu/"
SRC_URI="https://github.com/xrootd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~amd64-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=net-libs/xrootd-5.0.0
	sys-cluster/ceph"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/cppunit )"

# xrootd plugins are not intended to be linked with,
# they are to be loaded at runtime by xrootd,
# see https://github.com/xrootd/xrootd/issues/447
QA_SONAME="/usr/lib.*/libXrdCeph.*-$(ver_cut 1)\.so
	/usr/lib.*/libXrdCephTests\.so"

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
		# As of 5.0.3 the default plug-in version is still 4.
		-DPLUGIN_VERSION=$(ver_cut 1)
	)
	cmake_src_configure
}
