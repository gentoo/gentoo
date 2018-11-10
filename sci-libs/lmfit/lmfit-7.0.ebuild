# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="library for Levenberg-Marquardt least-squares minimization and curve fitting"
HOMEPAGE="http://apps.jcns.fz-juelich.de/doku/sc/lmfit"
SRC_URI="http://apps.jcns.fz-juelich.de/src/lmfit/old/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		-DINJECT_C_FLAGS=OFF
	)

	cmake-utils_src_configure
}
