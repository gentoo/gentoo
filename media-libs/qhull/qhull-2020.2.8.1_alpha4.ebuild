# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org"
MY_PV="$(ver_cut 3-)"
SRC_URI="https://github.com/qhull/qhull/archive/v${MY_PV/_/.}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV//_/.}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2 "${MY_PV}")"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos"
IUSE="doc static-libs tools test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( tools )"

DOCS=(
	Announce.txt
	File_id.diz
	README.txt
	REGISTER.txt
)

PATCHES=(
	"${FILESDIR}/${PN}-2020.2-deprecated-pkgconfig.patch"
	"${FILESDIR}/${PF}-update-version-alpha3.patch" # version string wasn't bumped in in alpha4
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
	# cmake-4 workaround
	local -x CMAKE_POLICY_VERSION_MINIMUM="${CMAKE_POLICY_VERSION_MINIMUM:-3.10}"

	local mycmakeargs=(
		-DDOC_INSTALL_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DLINK_APPS_SHARED="yes"

		-DBUILD_APPLICATIONS="$(usex tools)"
		-DBUILD_STATIC_LIBS="$(usex static-libs)"
		-DQHULL_ENABLE_TESTING="$(usex test)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# fix double prefix in pc files
	sed -i "/^libdir/s@/.*@/$(get_libdir)@" "${ED}/usr/$(get_libdir)/pkgconfig/"*.pc || die

	rm "${ED}/usr/$(get_libdir)/pkgconfig/qhull.pc" || die

	if ! use static-libs; then
		rm "${ED}/usr/$(get_libdir)/pkgconfig/qhull"{static,static_r,cpp}.pc || die
	fi
}
