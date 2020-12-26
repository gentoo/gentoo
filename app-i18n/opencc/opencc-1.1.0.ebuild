# Copyright 2010-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_7,3_8,3_9})

inherit cmake python-any-r1

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

# OpenCC: Apache-2.0
# deps/darts-clone: BSD-2
# deps/gtest-1.11.0: BSD
# deps/marisa-0.2.5: || ( BSD-2 LGPL-2.1+ )
# deps/rapidjson-1.1.0: MIT
# deps/tclap-1.2.2: MIT
LICENSE="Apache-2.0 BSD-2 MIT || ( BSD-2 LGPL-2.1+ ) test? ( BSD )"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"
DEPEND=""
RDEPEND=""

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/OpenCC-ver.${PV}"
fi

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-parallel_build.patch"
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
