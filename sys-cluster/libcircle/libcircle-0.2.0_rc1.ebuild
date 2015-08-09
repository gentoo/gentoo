# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/hpc/${PN}.git http://github.com/hpc/${PN}.git"
	inherit git-2
	KEYWORDS=""
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/hpc/${PN}/archive/${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
fi

DESCRIPTION="an API for distributing embarrassingly parallel workloads using self-stabilization"
HOMEPAGE="https://github.com/hpc/libcircle"

SLOT="0"
LICENSE="BSD"
IUSE="doc test"

RDEPEND="virtual/mpi"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"

DOCS=( HACKING.md README.md )

src_configure() {
	local myeconfargs=(
		$(use_enable test tests)
		$(use_enable doc doxygen)
	)
	autotools-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( "${BUILD_DIR}/doc/html/" )
	autotools-utils_src_install
}
