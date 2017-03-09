# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
inherit kde5 flag-o-matic

DESCRIPTION="Periodic table of the elements"
HOMEPAGE="https://www.kde.org/applications/education/kalzium
https://edu.kde.org/kalzium"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="editor solver"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep khtml)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kplotting)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kunitconversion)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	editor? (
		dev-cpp/eigen:3
		sci-chemistry/avogadro
		sci-chemistry/openbabel
	)
	solver? ( dev-ml/facile[ocamlopt] )
"
RDEPEND="${DEPEND}
	sci-chemistry/chemical-mime-data
"

src_prepare(){
	kde5_src_prepare
	cmake_comment_add_subdirectory qml
}

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	local mycmakeargs=(
		$(cmake-utils_use_find_package editor Eigen3)
		$(cmake-utils_use_find_package editor AvogadroLibs)
		$(cmake-utils_use_find_package editor OpenBabel2)
		$(cmake-utils_use_find_package solver OCaml)
		$(cmake-utils_use_find_package solver Libfacile)
	)

	kde5_src_configure
}
