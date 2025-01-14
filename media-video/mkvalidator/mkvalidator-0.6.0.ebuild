# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="mkvalidator is a command line tool to verify Matroska files for spec conformance"
HOMEPAGE="https://www.matroska.org/downloads/mkvalidator.html"
SRC_URI="https://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_SHARED_LIBS=OFF
	)

	cmake_src_configure
}

src_install() {
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README

	cd "${BUILD_DIR}" || die
	dobin mkvalidator/mkvalidator
}
