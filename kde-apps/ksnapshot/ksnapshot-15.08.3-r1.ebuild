# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_PV=2015.12

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Screenshot Utility"
HOMEPAGE="https://www.kde.org/applications/graphics/ksnapshot/"
SRC_URI="mirror://kde/stable/apps/KDE4.x/utils/${PN}-${MY_PV}.tar.xz"

KEYWORDS=" ~amd64 ~x86"
IUSE="debug kipi"

DEPEND="
	x11-libs/libXfixes
	!aqua? (
		x11-libs/libX11
		x11-libs/libXext
	)
	kipi? ( $(add_kdeapps_dep libkipi) )
"
RDEPEND="${DEPEND}
	!<kde-plasma/khotkeys-5.4.3-r1:5
"

S="${WORKDIR}/${PN}-${MY_PV}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with kipi)
	)

	kde4-base_src_configure
}
