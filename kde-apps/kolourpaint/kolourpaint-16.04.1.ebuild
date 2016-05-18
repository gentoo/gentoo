# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Paint Program by KDE"
HOMEPAGE="https://www.kde.org/applications/graphics/kolourpaint/"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD LGPL-2"
IUSE="debug scanner"

DEPEND="
	media-libs/qimageblitz
	scanner? ( $(add_kdeapps_dep libksane) )
"
RDEPEND="${DEPEND}
	scanner? ( $(add_kdeapps_dep ksaneplugin) )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package scanner KSane)
	)

	kde4-base_src_configure
}
