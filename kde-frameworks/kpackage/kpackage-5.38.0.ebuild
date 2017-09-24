# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Framework to install and load packages of non binary content"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="man"

RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
"
DEPEND="${RDEPEND}
	man? ( $(add_frameworks_dep kdoctools) )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}

src_test() {
	# bug 621458
	mkdir -p "${HOME}/.local/share/kservicetypes5" || die
	cp "${S}"/src/kpackage/data/servicetypes/*desktop "${HOME}/.local/share/kservicetypes5/" || die

	# tests cannot be run in parallel #606942; disable broken test #630664
	local myctestargs=(
		-j1
		-E "(plasma-querytest)"
	)

	kde5_src_test
}
