# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# solvespace's libdxfrw is quite heavily modified and incompatible with
# the upstream libdxfrw.
DXFRW_COMMIT="0b7b7b709d9299565db603f878214656ef5e9ddf"
DXFRW_PV="0.6.3"
DXFRW_P="libdxfrw-${DXFRW_PV}-${DXFRW_COMMIT}"

# dynamically linking with mimalloc causes segfaults when changing
# language. bug #852839
MIMALLOC_COMMIT="f819dbb4e4813fab464aee16770f39f11476bfea"
MIMALLOC_PV="2.0.6"
MIMALLOC_P="mimalloc-${MIMALLOC_PV}-${MIMALLOC_COMMIT}"

inherit cmake toolchain-funcs xdg

DESCRIPTION="Parametric 2d/3d CAD"
HOMEPAGE="http://solvespace.com"
SRC_URI="https://github.com/solvespace/solvespace/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/solvespace/libdxfrw/archive/${DXFRW_COMMIT}.tar.gz -> ${DXFRW_P}.tar.gz
	!system-mimalloc? ( https://github.com/microsoft/mimalloc/archive/${MIMALLOC_COMMIT}.tar.gz -> ${MIMALLOC_P}.tar.gz )"

# licenses
# + SolveSpace (GPL-3+)
# |- Bitstream Vera (BitstreamVera)
# + libdxfrw (GPL-2+)
# + mimalloc (MIT)

IUSE="openmp +system-mimalloc"
KEYWORDS="amd64 ~x86"
LICENSE="BitstreamVera GPL-2+ GPL-3+ !system-mimalloc? ( MIT )"
SLOT="0"

RDEPEND="
	dev-cpp/atkmm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0[X]
	dev-cpp/pangomm:1.4
	dev-libs/glib:2
	dev-libs/json-c:=
	dev-libs/libsigc++:2
	dev-libs/libspnav[X]
	media-libs/fontconfig
	media-libs/freetype:2[X]
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/gtk+:3[X]
	system-mimalloc? ( dev-libs/mimalloc:= )
"
DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
"
BDEPEND="virtual/pkgconfig"

# This is shown to the user in the UI and --version and should be
# updated during each version bump.
MY_HASH="70bde63cb32a7f049fa56cbdf924e2695fcb2916"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	rm -r extlib/libdxfrw || die
	mv "${WORKDIR}"/libdxfrw-${DXFRW_COMMIT} extlib/libdxfrw || die

	if use system-mimalloc; then
		# Ideally this patch would be applied unconditionally and it
		# would add an option like `-DUSE_SYSTEM_MIMALLOC=On', but
		# hopefully this patch is only needed temporarily and the odd
		# interactions with the system's libmimalloc will be fixed
		# shortly... :)
		PATCHES=( "${FILESDIR}"/${PN}-3.1-use-system-mimalloc.patch )
	else
		rm -r extlib/mimalloc || die
		mv "${WORKDIR}"/mimalloc-${MIMALLOC_COMMIT} extlib/mimalloc || die
	fi

	sed -i '/include(GetGitCommitHash)/d' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_OPENMP=$(usex openmp)
		-DGIT_COMMIT_HASH=${MY_HASH}
	)

	cmake_src_configure
}
