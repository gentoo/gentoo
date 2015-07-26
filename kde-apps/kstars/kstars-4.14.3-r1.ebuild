# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kstars/kstars-4.14.3-r1.ebuild,v 1.4 2015/07/25 12:10:09 pacho Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit flag-o-matic kde4-base

DESCRIPTION="KDE Desktop Planetarium"
HOMEPAGE="http://www.kde.org/applications/education/kstars http://edu.kde.org/kstars"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug fits indi"

REQUIRED_USE="indi? ( fits )"

DEPEND="
	dev-cpp/eigen:3
	$(add_kdeapps_dep libkdeedu)
	fits? ( >=sci-libs/cfitsio-0.390 )
	indi? ( >=sci-libs/indilib-0.9.8 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-indilib100.patch" )

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	local mycmakeargs=(
		$(cmake-utils_use_with fits CFitsio)
		$(cmake-utils_use_with indi)
	)

	kde4-base_src_configure
}
