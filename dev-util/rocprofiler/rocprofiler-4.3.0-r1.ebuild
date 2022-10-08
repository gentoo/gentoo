# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-any-r1

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/${PN}/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocr-runtime:${SLOT}
	>=dev-util/roctracer-${PV}-r3:${SLOT}
	"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
	dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	')
"

PATCHES=( "${FILESDIR}/${P}-fix-gcc11.patch"
		"${FILESDIR}/${PN}-4.3.0-nostrip.patch"
		"${FILESDIR}/${PN}-4.3.0-no-aqlprofile.patch"
		"${FILESDIR}/${PN}-4.3.0-ldflag.patch"
		"${FILESDIR}/${PN}-4.3.0-gentoo-location.patch" )

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]"
}

src_prepare() {
	sed -e "s,\${DEST_NAME}/lib,$(get_libdir),g" \
		-e "s,\${DEST_NAME}/include,include/\${DEST_NAME},g" \
		-e "s,\${DEST_NAME}/bin,bin,g" \
		-e "/ctrl DESTINATION/s,\${DEST_NAME}/tool,bin,g" \
		-e "/CPACK_RESOURCE_FILE_LICENSE/d" \
		-e "/libtool.so DESTINATION/s,\${DEST_NAME}/tool,$(get_libdir),g" -i CMakeLists.txt || die

	cmake_src_prepare

	sed -e "s,@LIB_DIR@,$(get_libdir),g" -i bin/rpl_run.sh || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa"
		-DPROF_API_HEADER_PATH="${EPREFIX}"/usr/include/roctracer/ext
		-DUSE_PROF_API=1
	)

	cmake_src_configure
}
