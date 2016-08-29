# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit kde4-base flag-o-matic

DESCRIPTION="Periodic table of the elements"
HOMEPAGE="https://www.kde.org/applications/education/kalzium
https://edu.kde.org/kalzium"
KEYWORDS="amd64 ~arm x86"
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

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	local mycmakeargs=(
		-DBUILD_plasmoid=$(usex plasma)
		-DWITH_Eigen3=$(usex editor)
		-DWITH_Avogadro=$(usex editor)
		-DWITH_OpenBabel2=$(usex editor)
		-DWITH_OCaml=$(usex solver)
		-DWITH_Libfacile=$(usex solver)
	)

	kde4-base_src_configure
}
