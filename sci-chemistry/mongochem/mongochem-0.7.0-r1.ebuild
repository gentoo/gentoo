# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils vcs-snapshot

DESCRIPTION="Application for managing large collections of chemical data"
HOMEPAGE="http://www.openchemistry.org/"
#SRC_URI="http://openchemistry.org/files/v0.5/${P}.tar.gz"
SRC_URI="https://github.com/OpenChemistry/mongochem/archive/df36ebce92024dd4fd1c70eb37eb84e4c51120ff.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/boost[threads]
	dev-libs/mongo-cxx-driver
	sci-libs/avogadrolibs[qt4]
	sci-libs/chemkit
	sci-libs/vtk[qt4,rendering]
	sci-chemistry/molequeue
"
DEPEND="${RDEPEND}"
