# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib multilib optfeature python-single-r1

DESCRIPTION="Tool for tracing, analyzing, and debugging graphics APIs"
HOMEPAGE="https://github.com/apitrace/apitrace"
BACKTRACE_COMMIT="8602fda64e78f1f46563220f2ee9f7e70819c51d"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ianlancetaylor/libbacktrace/archive/${BACKTRACE_COMMIT}.tar.gz
		-> ${P}-libbacktrace-${BACKTRACE_COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gui test X"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${PYTHON_DEPS}
	app-arch/brotli:=[${MULTILIB_USEDEP}]
	app-arch/snappy:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=
	media-libs/waffle[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	gui? ( dev-qt/qtbase:6[-gles2-only,gui,widgets] )
	X? ( x11-libs/libX11 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-9.0-disable-multiarch.patch
	"${FILESDIR}"/${PN}-12.0-find_snappy.patch
	"${FILESDIR}"/${PN}-12.0-tests.patch
	"${FILESDIR}"/${PN}-12.0-unbundle.patch

	# merged, to be removed for the next version
	"${FILESDIR}"/${PN}-9.0-pkgconfig-waffle.patch
	"${FILESDIR}"/${PN}-12.0-include-stdint.patch
	"${FILESDIR}"/${PN}-12.0-no_qtnetwork.patch
	"${FILESDIR}"/${PN}-12.0-bump_cmake_min.patch
)

src_prepare() {
	sed -e "s:0.0-unknown:${PV}:" -i cmake/GenerateVersion.cmake || die

	# still 3rd libs: khronos, crc32c and md5-compat
	rm -r $(find thirdparty -mindepth 1 -maxdepth 1 \
		! -name crc32c \
		! -name khronos \
		! -name md5 \
		! -name support \
		-type d -print) || die

	mv "${WORKDIR}"/libbacktrace-${BACKTRACE_COMMIT} thirdparty/libbacktrace || die

	cmake_src_prepare
}

src_configure() {
	my_configure() {
		local mycmakeargs=(
			-DBUILD_TESTING=$(usex test)
			-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}
			-DENABLE_X11=$(usex X)
			-DENABLE_EGL=ON
			-DENABLE_CLI=ON
			-DENABLE_GUI=$(multilib_native_usex gui)
			-DENABLE_QT6=$(multilib_native_usex gui)
			-DENABLE_STATIC_SNAPPY=OFF
			-DENABLE_WAFFLE=ON
			-DPython3_EXECUTABLE="${PYTHON}"
		)
		cmake_src_configure
	}

	multilib_foreach_abi my_configure
}

src_install() {
	MULTILIB_CHOST_TOOLS=(
		/usr/bin/apitrace$(get_exeext)
		/usr/bin/eglretrace$(get_exeext)
		/usr/bin/gltrim$(get_exeext)
	)
	use X && MULTILIB_CHOST_TOOLS+=( /usr/bin/glretrace$(get_exeext) )

	cmake-multilib_src_install

	make_libegl_symlinks() {
		dosym egltrace.so /usr/$(get_libdir)/${PN}/wrappers/libEGL.so
		dosym egltrace.so /usr/$(get_libdir)/${PN}/wrappers/libEGL.so.1
	}
	multilib_foreach_abi make_libegl_symlinks

	make_libgl_symlinks() {
		dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so
		dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so.1
		dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so.1.2
	}
	use X && multilib_foreach_abi make_libgl_symlinks
}

pkg_postinst() {
	optfeature "retracediff.py: side by side retracing" "dev-python/pillow" "dev-python/numpy"
	optfeature "snapdiff.py: image comparison scripts" "dev-python/pillow"
}
