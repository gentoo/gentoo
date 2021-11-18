# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org"
SRC_URI="https://github.com/qhull/qhull/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/8"
LICENSE="BSD"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc static-libs"

DOCS=( Announce.txt File_id.diz README.txt REGISTER.txt )

PATCHES=(
	"${FILESDIR}/${PN}-2020.2-deprecated-pkgconfig.patch"
)

src_prepare() {
	if ! use doc ; then
		sed -i \
			-e '/^install(DIRECTORY html/d' \
			-e '/^[[:blank:]]*index.htm/d' \
			CMakeLists.txt || die
	fi

	sed -i \
		-e "s@lib/pkgconfig@$(get_libdir)/pkgconfig@" \
		-e "s@lib/cmake/Qhull@$(get_libdir)/cmake/Qhull@" \
		CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DLINK_APPS_SHARED=ON
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile all libqhull
}

src_install() {
	cmake_src_install
	dolib.so "${BUILD_DIR}"/libqhull.so*

	# fix double prefix in pc files
	sed -i "/^libdir/s@/.*@/$(get_libdir)@" "${ED}/usr/$(get_libdir)/pkgconfig/"*.pc || die

	if ! use static-libs; then
		rm "${ED}/usr/$(get_libdir)/pkgconfig/qhull"{static,static_r,cpp}.pc || die
		rm -r "${ED}/usr/include/libqhullcpp" || die
	fi
}
