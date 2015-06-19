# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libindicate-qt/libindicate-qt-0.2.5.91.ebuild,v 1.6 2014/10/31 13:37:03 kensington Exp $

EAPI=4
inherit eutils virtualx cmake-utils

_UBUNTU_REVISION=5

DESCRIPTION="Qt wrapper for libindicate library"
HOMEPAGE="https://launchpad.net/libindicate-qt/"
SRC_URI="mirror://ubuntu/pool/main/libi/${PN}/${PN}_${PV}.orig.tar.bz2
	mirror://ubuntu/pool/main/libi/${PN}/${PN}_${PV}-${_UBUNTU_REVISION}.debian.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-libs/libindicate-12.10.0
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:4 )
	virtual/pkgconfig"

# bug #440042
RESTRICT="test"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=diff epatch "${WORKDIR}"/debian/patches
	epatch "${FILESDIR}"/${P}-optionaltests.patch
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		$(cmake-utils_use_build test TESTS)
	)

	cmake-utils_src_configure
}

src_test() {
	local ctestargs
	[[ -n ${TEST_VERBOSE} ]] && ctestargs="--extra-verbose --output-on-failure"

	cd "${CMAKE_BUILD_DIR}"/tests

	VIRTUALX_COMMAND="ctest ${ctestargs}" virtualmake || die
}
