# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
KFMIN=5.63.0
QTMIN=5.12.3
inherit ecm kde.org flag-o-matic

DESCRIPTION="Periodic table of the elements"
HOMEPAGE="https://kde.org/applications/education/org.kde.kalzium
https://edu.kde.org/kalzium/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="editor solver"

DEPEND="
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/kitemviews-${KFMIN}:5
	>=kde-frameworks/kplotting-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kunitconversion-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtscript-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	editor? (
		>=kde-frameworks/knewstuff-${KFMIN}:5
		>=dev-qt/qtopengl-${QTMIN}:5
		dev-cpp/eigen:3
		sci-chemistry/openbabel
		sci-libs/avogadrolibs[qt5]
	)
	solver? ( dev-ml/facile[ocamlopt] )
"
RDEPEND="${DEPEND}
	sci-chemistry/chemical-mime-data
"

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	local mycmakeargs=(
		$(cmake_use_find_package editor Eigen3)
		$(cmake_use_find_package editor AvogadroLibs)
		$(cmake_use_find_package editor OpenBabel2)
		$(cmake_use_find_package solver OCaml)
		$(cmake_use_find_package solver Libfacile)
	)

	ecm_src_configure
}
