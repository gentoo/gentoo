# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoptional"
KFMIN=6.9.0
QTMIN=6.7.2
inherit ecm gear.kde.org flag-o-matic xdg

DESCRIPTION="Periodic table of the elements"
HOMEPAGE="https://apps.kde.org/kalzium/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="solver"

# TODO: IUSE="editor"
# 	editor? (
# 		dev-cpp/eigen:3
# 		>=dev-qt/qtopengl-${QTMIN}:6
# 		>=kde-frameworks/knewstuff-${KFMIN}:6
# 		sci-chemistry/openbabel:=
# 		>=sci-libs/avogadrolibs-1.93[qt6]
# 	)
DEPEND="
	>=dev-qt/qt5compat-${QTMIN}:6
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=dev-qt/qtscxml-${QTMIN}:6
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kplotting-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kunitconversion-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	solver? ( dev-ml/facile:=[ocamlopt] )
"
RDEPEND="${DEPEND}
	sci-chemistry/chemical-mime-data
"

PATCHES=( "${FILESDIR}/${PN}-21.03.90-cmake.patch" )

src_configure() {
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenBabel3=ON # TODO: bug 823101
		-DCMAKE_DISABLE_FIND_PACKAGE_Eigen3=ON
# 		$(cmake_use_find_package editor Eigen3)
# 		$(cmake_use_find_package editor AvogadroLibs)
# 		$(cmake_use_find_package editor OpenBabel2)
# 		$(cmake_use_find_package solver OCaml)
# 		$(cmake_use_find_package solver Libfacile)
	)

	ecm_src_configure
}
