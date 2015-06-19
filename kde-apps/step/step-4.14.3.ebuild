# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/step/step-4.14.3.ebuild,v 1.1 2015/06/04 18:44:45 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="The KDE physics simulator"
HOMEPAGE="http://edu.kde.org/step"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug +gsl +qalculate"

DEPEND="
	>=dev-cpp/eigen-2.0.3:2
	gsl? ( >=sci-libs/gsl-1.9-r1 )
	qalculate? ( >=sci-libs/libqalculate-0.9.5 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with gsl)
		$(cmake-utils_use_with qalculate)
	)
	kde4-base_src_configure
}
