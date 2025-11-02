# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Efficient Probabilistic 3D Mapping Framework Based on Octrees"
HOMEPAGE="https://octomap.github.io/"
SRC_URI="https://github.com/OctoMap/octomap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD qt6? ( GPL-2 )"
SLOT="0/1.10"
KEYWORDS="~amd64 ~arm"
IUSE="doc dynamicEDT3D qt6"

RDEPEND="
	qt6? (
		dev-qt/qtbase:6[gui,widgets,xml]
		>=x11-libs/libQGLViewer-2.9.1
		virtual/glu
		virtual/opengl
	)
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen[dot] )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.0-cmake_bump.patch
	"${FILESDIR}"/${PN}-1.10.0-destdir_edt3d.patch
	"${FILESDIR}"/${PN}-1.10.0-filter_flags.patch
	"${FILESDIR}"/${PN}-1.10.0-pkgconf_libqglviewer.patch
	"${FILESDIR}"/${PN}-1.10.0-qt5_qt6.patch
)

src_prepare() {
	if use doc; then
		doxygen -u octomap/octomap.dox.in 2>/dev/null || die
		doxygen -u dynamicEDT3D/dynamicEDT3D.dox 2>/dev/null || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_DYNAMICETD3D_SUBPROJECT=$(usex dynamicEDT3D)
		-DBUILD_OCTOVIS_SUBPROJECT=$(usex qt6)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_build docs
		use dynamicEDT3D && cmake_build docs_dynamicEDT3D
		# remove doxygen working files
		find "${S}" \( \
			-iname '*.map' -o \
			-iname '*.md5' \
			\) -delete || die
	fi
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}/lib"
	cmake_src_test
}

src_install() {
	if use doc; then
		# use docinto to preserve one subdirectory by project in html dir
		docinto html/octomap
		dodoc -r octomap/doc/html/.
		if use dynamicEDT3D; then
			docinto html/dynamicEDT3D
			dodoc -r dynamicEDT3D/doc/html/.
		fi
	fi

	cmake_src_install

	# dir with empty files
	rm -r "${ED}"/usr/share/ament_index || die

	# breaks octomap-targets.cmake (used eg by rtabmap)
	# find "${ED}" -name '*.a' -delete || die
}
