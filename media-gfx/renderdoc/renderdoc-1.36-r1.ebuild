# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic optfeature verify-sig xdg

DESCRIPTION="Standalone graphics debugging tool"
HOMEPAGE="https://renderdoc.org https://github.com/baldurk/renderdoc"
SRC_URI="
	https://github.com/baldurk/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	verify-sig? ( https://github.com/baldurk/renderdoc/releases/download/v${PV}/v${PV}.tar.gz.asc -> ${P}.tar.gz.asc )
"

# renderdoc: MIT
#   + cmdline: BSD (not compatible with upstream lib)
#   + farm fresh icons: CC-BY-3.0
#   + half: MIT (not compatible with system dev-libs/half)
#   + include-bin ZLIB (upstream doesn't exist anymore, maintained in tree)
#   + md5: public-domain
#   + plthook: BSD-2
#   + pugixml: MIT
#   + radeon gpu analyzer: MIT
#   + source code pro: OFL-1.1
#   + stb: public-domain
#   + tinyfiledialogs: ZLIB
#   + glslang: BSD
#   + docs? ( sphinx.paramlinks: MIT )
# swig: GPL-3+ BSD BSD-2
LICENSE="BSD BSD-2 CC-BY-3.0 GPL-3+ MIT OFL-1.1 public-domain ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/miniz:=
	x11-libs/libX11
	x11-libs/libxcb:=
	x11-libs/xcb-util-keysyms
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	x11-base/xorg-proto
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-baldurkarlsson )
"

PATCHES=(
	# The analytics seem very reasonable, and even without this patch
	# they are NOT sent before the user accepts.  But default the
	# selection to off, just in case.
	"${FILESDIR}"/${PN}-1.18-analytics-off.patch

	# Only search for PySide2 if pyside2 USE flag is set. Bug #833627
	"${FILESDIR}"/${PN}-1.18-conditional-pyside.patch

	# Pass CXXFLAGS and LDFLAGS through to qmake when qrenderdoc is built
	"${FILESDIR}"/${PN}-1.18-system-flags.patch

	# Needed to prevent sandbox violations during build
	"${FILESDIR}"/${PN}-1.27-env-home.patch

	"${FILESDIR}"/${PN}-1.30-r1-system-compress.patch

	# Bug #925578
	"${FILESDIR}"/${PN}-1.31-lld.patch

	"${FILESDIR}"/${PN}-1.36-gcc15-fix.patch
	"${FILESDIR}"/${PN}-1.36-cmake4.patch # bug 964518
)

DOCS=( util/LINUX_DIST_README )

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/baldurkarlsson.gpg

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi

	# Do not unpack the swig sources here.  CMake will do that if
	# required.
	unpack ${P}.tar.gz
}

src_prepare() {
	rm -r util/test || die # unused, but triggers # 961634

	cmake_src_prepare

	# Remove the calls to install the documentation files.  Instead,
	# install them with einstalldocs.
	sed -i '/share\/doc\/renderdoc/d' \
		CMakeLists.txt qrenderdoc/CMakeLists.txt || die

	# Assumes that the build directory is "${S}"/build, which it is not
	sed -i "s|../build/lib|${BUILD_DIR}/lib|" docs/conf.py || die

	# Bug #836235
	sed -i '/#include <stdarg/i #include <time.h>' \
		renderdoc/os/os_specific.h || die
}

src_configure() {
	local mycmakeargs=(
		# Build system does not know that this is a tagged release, as
		# we just have the tarball and not the git repository.
		-DBUILD_VERSION_STABLE=ON

		-DENABLE_EGL=ON
		-DENABLE_GL=ON
		-DENABLE_GLES=ON
		-DENABLE_PYRENDERDOC=OFF # disable Qt5
		-DENABLE_QRENDERDOC=OFF # disable Qt5
		-DENABLE_VULKAN=ON

		# Upstream says that this option is unsupported and should not
		# be used yet.
		-DENABLE_UNSUPPORTED_EXPERIMENTAL_POSSIBLY_BROKEN_WAYLAND=OFF

		-DENABLE_XCB=ON
		-DENABLE_XLIB=ON

		# renderdoc_capture.json is installed here
		-DVULKAN_LAYER_FOLDER="${EPREFIX}"/etc/vulkan/implicit_layer.d
	)

	# Lots of type mismatch issues.
	filter-lto

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "android remote contexts" dev-util/android-tools
	optfeature "vulkan contexts" media-libs/vulkan-loader
}
