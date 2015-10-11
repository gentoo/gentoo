# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
CPPUNIT_REQUIRED="optional"
VIRTUALX_REQUIRED="test"
inherit kde4-meta

DESCRIPTION="KSysguard is a network enabled task manager and system monitor application"
HOMEPAGE+=" https://userbase.kde.org/KSysGuard"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug lm_sensors test"

DEPEND="
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXres
	lm_sensors? ( sys-apps/lm_sensors )
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# bug 393091

KMEXTRA="
	libs/ksysguard/
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with lm_sensors Sensors)
	)

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst
	ewarn "Note that ksysguard has powerful features; one of these is the executing of arbitrary"
	ewarn "programs with elevated privileges (as data sources). So be careful opening worksheets"
	ewarn "from untrusted sources!"
}
