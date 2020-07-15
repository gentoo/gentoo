# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

MY_PN="CuraEngine"

DESCRIPTION="A 3D model slicing engine for 3D printing"
HOMEPAGE="https://github.com/Ultimaker/CuraEngine"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+arcus doc openmp test"
RESTRICT="!test? ( test )"

RDEPEND="
  ${PYTHON_DEPS}
	arcus? (
		~dev-libs/libarcus-${PV}:*
		dev-libs/protobuf:=
	)
	dev-libs/clipper
	dev-libs/rapidjson
	dev-libs/stb"
BDEPEND="${RDEPEND}
  || ( sys-devel/gcc sys-devel/clang )
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/gtest )
"

DOCS=( README.md )

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# remove static linking
	sed --in-place --expression="s/-static-libstdc++//g" CMakeLists.txt || die

  if use test; then
		find "${S}"/tests/arcus "${S}"/tests/integration "${S}"/tests/settings "${S}"/tests/utils \
		 -type f -name '*.cpp' | xargs sed --in-place \
			--expression='s <../src/utils/AABB.h> "../../src/utils/AABB.h" g'\
			--expression='s <../src/utils/IntPoint.h> "../../src/utils/IntPoint.h" g' \
			--expression='s <../src/utils/polygon.h> "../../src/utils/polygon.h" g'\
			--expression='s <../src/utils/PolygonConnector.h> "../../src/utils/PolygonConnector.h" g'\
			--expression='s <../src/utils/polygonUtils.h> "../../src/utils/polygonUtils.h" g'\
			--expression='s <../src/utils/string.h> "../../src/utils/string.h" g' \
      --expression='s#include "../src#include "../../src#g'|| die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test ON OFF)
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_ARCUS=$(usex arcus on off)
		-DENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS=OFF
		-DENABLE_OPENMP=$(usex openmp on off)
		-DUSE_SYSTEM_LIBS=ON
	)

	cmake_src_configure
}

src_compile() {
	cmake_build

	if use doc; then
		doxygen || die
		mv docs/html . || die
		find html -name '*.md5' -or -name '*.map' -delete || die
		HTML_DOCS=( html )
	fi
}
