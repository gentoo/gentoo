# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
CPPUNIT_REQUIRED="optional"
OPENGL_REQUIRED="always"
inherit kde4-base flag-o-matic

DESCRIPTION="KDE: periodic table of the elements"
HOMEPAGE="http://www.kde.org/applications/education/kalzium
http://edu.kde.org/kalzium"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="editor debug +plasma solver"

DEPEND="
	$(add_kdeapps_dep libkdeedu)
	editor? (
		>=dev-cpp/eigen-2.0.3:2
		sci-chemistry/avogadro
		>=sci-chemistry/openbabel-2.2
	)
	solver? ( dev-ml/facile[ocamlopt] )
"
RDEPEND=${DEPEND}

KMEXTRACTONLY="
	libkdeedu/kdeeduui/
	libkdeedu/libscience/
"

src_configure(){
	# Fix missing finite()
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DHAVE_IEEEFP_H

	local mycmakeargs=(
		$(cmake-utils_use_with editor Eigen2)
		$(cmake-utils_use_with editor Avogadro)
		$(cmake-utils_use_with editor OpenBabel2)
		$(cmake-utils_use_with editor OpenGL)
		$(cmake-utils_use_with solver OCaml)
		$(cmake-utils_use_with solver Libfacile)
	)

	kde4-base_src_configure
}
