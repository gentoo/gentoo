# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="kioslaves from kdesdk package"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug"

src_configure() {
	local mycmakeargs=(
		-DWITH_SVN=OFF
	)

	kde4-base_src_configure
}
