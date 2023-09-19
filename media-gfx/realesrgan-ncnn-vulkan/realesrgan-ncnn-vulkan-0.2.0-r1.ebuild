# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="NCNN implementation of Real-ESRGAN"
HOMEPAGE="https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan"
SRC_URI="
	https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~slashbeast/distfiles/${PN}/${PN}-models.tar.xz
"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/ncnn:=[vulkan]
	media-libs/libwebp:=
	media-libs/vulkan-loader"
DEPEND="
	${RDEPEND}
	dev-util/glslang
	dev-util/vulkan-headers"

PATCHES=(
	"${FILESDIR}"/"${PN}"-default-realesrgan-x4plus-model.patch
)

S="${WORKDIR}/Real-ESRGAN-ncnn-vulkan-${PV}"

src_prepare() {
	rm -rf "src/libwebp" "src/ncnn"

	CMAKE_USE_DIR=${S}/src
	cmake_src_prepare

	# Update all paths to match installation for models.
	sed "s%PATHSTR(\"models\")%PATHSTR(\"${EPREFIX}/usr/share/${PN}/models\")%g" \
		-i src/main.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DGLSLANG_TARGET_DIR="${ESYSROOT}"/usr/$(get_libdir)/cmake
		-DUSE_SYSTEM_NCNN=ON
		-DUSE_SYSTEM_WEBP=ON
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/realesrgan-ncnn-vulkan

	insinto /usr/share/${PN}/models
	doins -r ../models/.
}
