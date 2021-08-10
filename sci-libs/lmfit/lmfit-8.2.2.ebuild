# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="library for Levenberg-Marquardt least-squares minimization and curve fitting"
HOMEPAGE="https://jugit.fz-juelich.de/mlz/lmfit"
SRC_URI="http://apps.jcns.fz-juelich.de/src/lmfit/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )

src_configure() {
	local mycmakeargs=(
		-DINJECT_C_FLAGS=OFF
	)
	cmake_src_configure
}
