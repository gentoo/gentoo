# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit virtualx cmake-utils

_UBUNTU_REVISION=5

DESCRIPTION="Qt wrapper for libindicate library"
HOMEPAGE="https://launchpad.net/libindicate-qt/"
SRC_URI="mirror://ubuntu/pool/main/libi/${PN}/${PN}_${PV}.orig.tar.bz2
	mirror://ubuntu/pool/main/libi/${PN}/${PN}_${PV}-${_UBUNTU_REVISION}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-libs/libindicate-12.10.0
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-qt/qttest:4 )
"

# bug #440042
RESTRICT="test"

src_prepare() {
	eapply "${WORKDIR}"/debian/patches
	eapply "${FILESDIR}"/${P}-optionaltests.patch
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DBUILD_TESTS=$(usex test)
	)

	cmake-utils_src_configure
}

src_test() {
	local ctestargs
	[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"

	cd "${CMAKE_BUILD_DIR}"/tests

	VIRTUALX_COMMAND="ctest ${ctestargs}" virtualmake || die
}
