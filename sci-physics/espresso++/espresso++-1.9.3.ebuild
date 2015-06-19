# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/espresso++/espresso++-1.9.3.ebuild,v 1.2 2014/11/13 17:52:48 ottxor Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
CMAKE_MAKEFILE_GENERATOR="ninja"

inherit cmake-utils python-single-r1

DESCRIPTION="extensible, flexible, fast and parallel simulation software for soft matter research"
HOMEPAGE="https://www.espresso-pp.de"

if [[ ${PV} = 9999 ]]; then
	EHG_REPO_URI="https://bitbucket.org/${PN//+/p}/${PN//+/p}"
	inherit mercurial
	KEYWORDS=
else
	inherit vcs-snapshot
	#SRC_URI="https://espressopp.mpip-mainz.mpg.de/Download/${PN//+/p}-${PV}.tgz"
	SRC_URI="https://bitbucket.org/${PN//+/p}/${PN//+/p}/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	virtual/mpi
	dev-libs/boost:=[python,mpi,${PYTHON_USEDEP}]
	sci-libs/fftw:3.0
	dev-python/mpi4py"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DEXTERNAL_BOOST=ON
		-DEXTERNAL_MPI4PY=ON
		-DWITH_RC_FILES=OFF
	)
	cmake-utils_src_configure
}
