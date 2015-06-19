# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/ksnapshot/ksnapshot-4.14.3.ebuild,v 1.1 2015/06/04 18:44:47 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Screenshot Utility"
HOMEPAGE="http://www.kde.org/applications/graphics/ksnapshot/"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug kipi"

DEPEND="
	x11-libs/libXfixes
	!aqua? (
		x11-libs/libX11
		x11-libs/libXext
	)
	kipi? ( $(add_kdeapps_dep libkipi) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with kipi)
	)

	kde4-base_src_configure
}
