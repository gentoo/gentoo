# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/hoomd-blue/hoomd-blue-1.0.2.ebuild,v 1.1 2015/03/01 05:10:07 ottxor Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils cuda python-single-r1

DESCRIPTION="a general-purpose particle simulation toolkit"
HOMEPAGE="http://codeblue.umich.edu/hoomd-blue/"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://bitbucket.org/glotzer/${PN}.git"
	inherit git-r3
	KEYWORDS=
else
	inherit vcs-snapshot
	SRC_URI="https://bitbucket.org/glotzer/${PN}/get/v${PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="hoomd-blue"
SLOT="0"
IUSE="cuda doc test mpi +zlib"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	mpi? ( virtual/mpi )
	cuda? ( dev-util/nvidia-cuda-sdk )
	zlib? ( sys-libs/zlib )
	dev-libs/boost:=[threads,python,mpi,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	use cuda && cuda_src_prepare

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable mpi MPI)
		$(cmake-utils_use_enable doc DOXYGEN)
		$(cmake-utils_use_enable cuda CUDA)
		$(cmake-utils_use_enable zlib ZLIB)
		$(cmake-utils_use_build test BUILD_TESTING)
		-DPYTHON_SITEDIR=$(python_get_sitedir)
	)
	cmake-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/hoomd-*doc* )
	cmake-utils_src_install

	sed -i "s/^python/${EPYTHON}/" "${ED}"/usr/bin/hoomd || die
}
