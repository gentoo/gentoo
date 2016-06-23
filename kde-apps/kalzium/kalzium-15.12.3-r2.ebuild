# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit kde4-base flag-o-matic

DESCRIPTION="KDE: periodic table of the elements"
HOMEPAGE="https://www.kde.org/applications/education/kalzium
https://edu.kde.org/kalzium"
KEYWORDS="amd64 x86"
IUSE="debug editor +plasma solver"

DEPEND="
	editor? (
		dev-cpp/eigen:3
		sci-chemistry/avogadro
		>=sci-chemistry/openbabel-2.2
		dev-qt/qtopengl:4
	)
	solver? ( dev-ml/facile[ocamlopt] )
"
RDEPEND="${DEPEND}
	sci-chemistry/chemical-mime-data
"

PATCHES=( "${FILESDIR}/${PN}-15.12.3-plasmoids.patch" )

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	local mycmakeargs=(
		$(cmake-utils_use_build plasma plasmoid)
		$(cmake-utils_use_with editor Eigen3)
		$(cmake-utils_use_with editor Avogadro)
		$(cmake-utils_use_with editor OpenBabel2)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)
	)

	kde4-base_src_configure
}
