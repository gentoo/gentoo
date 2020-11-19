# Copyright 2010-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/BYVoid/OpenCC"
fi

DESCRIPTION="Library for conversion between Traditional and Simplified Chinese characters"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/BYVoid/OpenCC/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Apache-2.0"
SLOT="0/2"
KEYWORDS=""
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"
DEPEND=""
RDEPEND=""

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/OpenCC-ver.${PV}"
fi

PATCHES=(
	"${FILESDIR}/${PN}-test.patch"
	"${FILESDIR}/${PN}-stop-copy.patch"
)

DOCS=(AUTHORS NEWS.md README.md)

src_prepare() {
	cmake_src_prepare

	sed -e "s:\${DIR_SHARE_OPENCC}/doc:share/doc/${PF}:" -i doc/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_GTEST=$(usex test ON OFF)
	)

	cmake_src_configure
}
