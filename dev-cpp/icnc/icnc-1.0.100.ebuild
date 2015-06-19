# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/icnc/icnc-1.0.100.ebuild,v 1.3 2015/03/06 22:05:30 ottxor Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils multilib python-any-r1

DESCRIPTION="Intel Concurrent Collections for C++ - Parallelism without the Pain"
HOMEPAGE="https://software.intel.com/en-us/articles/intel-concurrent-collections-for-cc"

if [[ $PV = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/icnc/icnc.git"
	KEYWORDS=
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc examples mpi test"
RESTRICT="test" #currently tests only work if icnc is already installed

RDEPEND="
	>=dev-cpp/tbb-4.2
	sys-libs/glibc
	mpi? ( virtual/mpi )
	"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( ${PYTHON_DEPS} )
	"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use mpi BUILD_LIBS_FOR_MPI)
		-DLIB=$(get_libdir)
		$(cmake-utils_use_find_package doc Doxygen)
	)
	cmake-utils_src_configure
	if use test ; then
		mycmakeargs=( -DRUN_DIST=OFF )
		CMAKE_USE_DIR="${S}/tests" \
			BUILD_DIR="${WORKDIR}/${P}_tests_build" \
			cmake-utils_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile
	use test && BUILD_DIR="${WORKDIR}/${P}_tests_build" cmake-utils_src_compile
}

src_test() {
	BUILD_DIR="${WORKDIR}/${P}_tests_build" cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	if use doc ; then
		insinto /usr/share/doc/${P}/html
		doins -r "${ED}"/usr/doc/api/*
	fi
	rm -fr "${ED}"/usr/doc
	if use examples ; then
		insinto /usr/share/${PN}/examples
		doins -r "${ED}"/usr/samples/*
	fi
	rm -r "${ED}"/usr/samples || die
	insinto /usr/share/${PN}/
	doins -r "${ED}"/usr/misc/*
	rm -r "${ED}"/usr/misc/ || die
}
