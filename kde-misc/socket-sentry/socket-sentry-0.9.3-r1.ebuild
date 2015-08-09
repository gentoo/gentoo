# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base user

MY_PN="socketsentry"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A KDE plasmoid that displays real-time network traffic on your Linux computer"
HOMEPAGE="http://code.google.com/p/socket-sentry"
SRC_URI="http://socket-sentry.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug test"

RDEPEND="
	>=net-libs/libpcap-0.8
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gmock dev-cpp/gtest )
"

PATCHES=( "${FILESDIR}/${PN}-0.9.3-automagictests.patch" )

S="${WORKDIR}/${MY_P}"

# tests fails to build, new gtest related?
RESTRICT="test"

pkg_setup() {
	kde4-base_pkg_setup

	SOCKETSENTRY_GROUP=${MY_PN}
	enewgroup ${SOCKETSENTRY_GROUP}
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with test TESTS)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	ewarn
	ewarn "Remember, in order to use ${PN} plasmoid, you have to"
	ewarn "be in the '${SOCKETSENTRY_GROUP}' group."
	ewarn
	ewarn "Just run 'gpasswd -a <USER> ${SOCKETSENTRY_GROUP}', then have <USER> re-login."
	ewarn
}
