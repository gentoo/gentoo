# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/BYVoid/OpenCC"
fi

DESCRIPTION="Project for conversion between Traditional and Simplified Chinese"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/BYVoid/OpenCC/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0/2"
KEYWORDS=""
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/OpenCC-ver.${PV}"
fi

DOCS=(AUTHORS NEWS.md README.md)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_GTEST=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use doc; then
		mv "${ED}usr/share/opencc/doc/html" "${ED}usr/share/doc/${P}/html" || die
		rmdir "${ED}usr/share/opencc/doc" || die
	fi
}
