# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="OpenTimelineIO"

DESCRIPTION="Open Source API and interchange format for editorial timeline information"
HOMEPAGE="https://github.com/AcademySoftwareFoundation/OpenTimelineIO"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AcademySoftwareFoundation/OpenTimelineIO.git"
	EGIT_SUBMODULES=( 'src/deps/rapidjson' )
else
	# Rapidjson hasn't had a release since 2016. OpenTimelineIO builds against rapidjson HEAD.
	RAPIDJSON_COMMIT="24b5e7a8b27f42fa16b96fc70aade9106cf7102f"

	SRC_URI="
		https://github.com/AcademySoftwareFoundation/OpenTimelineIO/archive/refs/tags/v${PV}.tar.gz
			-> ${MY_PN}-${PV}.tar.gz
		https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz
			-> rapidjson-${RAPIDJSON_COMMIT}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
IUSE="test"
RESTRICT="!test? ( test )"

# Check on update
# https://github.com/AcademySoftwareFoundation/OpenTimelineIO/pull/1852
RDEPEND="
	dev-libs/imath:3=
"
DEPEND="${RDEPEND}"

DOCS=(
	README.md
)

src_prepare() {
	if [[ "${PV}" != *9999* ]]; then
		mv -T "${WORKDIR}/rapidjson-${RAPIDJSON_COMMIT}" "src/deps/rapidjson" || die
	fi

	sed \
		-e "s/\(find_package(Imath \)QUIET/\1REQUIRED/" \
		-e "s/\(find_package(IlmBase \)QUIET/\1REQUIRED/" \
		-e "s|\(set(OTIO_RESOLVED_CXX_DYLIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/\)lib\")|\1$(get_libdir)\")|" \
		-i CMakeLists.txt || die

	sed \
		"s|share/opentime|$(get_libdir)/cmake/opentime|g" \
		-i src/opentime{,lineio}/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING="$(usex test)"
		-DOTIO_AUTOMATIC_SUBMODULES="no"

		-DOTIO_FIND_IMATH="yes"
		-DOTIO_IMATH_LIBS=""
		-DOTIO_SHARED_LIBS="yes"

		-DOTIO_CXX_COVERAGE="no"
		-DOTIO_CXX_EXAMPLES="no"
		-DOTIO_CXX_INSTALL="yes"
		-DOTIO_DEPENDENCIES_INSTALL="no"

		-DOTIO_PYTHON_INSTALL="no"
	)

	cmake_src_configure
}
