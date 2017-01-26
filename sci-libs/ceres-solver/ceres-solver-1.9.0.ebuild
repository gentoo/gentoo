# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils multilib python-any-r1 toolchain-funcs

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="http://ceres-solver.org/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="cxsparse doc examples gflags lapack openmp protobuf +schur sparse static-libs test"
REQUIRED_USE="test? ( gflags ) sparse? ( lapack )"

RDEPEND="
	dev-cpp/glog[gflags?]
	cxsparse? ( sci-libs/cxsparse:0= )
	lapack? ( virtual/lapack )
	protobuf? ( dev-libs/protobuf )
	sparse? (
		sci-libs/amd:0=
		sci-libs/camd:0=
		sci-libs/ccolamd:0=
		sci-libs/cholmod:0=
		sci-libs/colamd:0=
		sci-libs/spqr:0= )"

DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	doc? ( dev-python/sphinx dev-python/sphinx_rtd_theme )
	lapack? ( virtual/pkgconfig )"

PATCHES=( "${FILESDIR}"/${P}-underlink.patch )

pkg_setup() {
	# XXX: this looks like it should be used with BUILD_TYPE!=binary
	if use openmp; then
		if [[ $(tc-getCXX) == *g++* ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# search paths work for prefix
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		cmake/*.cmake || die

	# remove Werror
	sed -i \
		-e 's/-Werror//g' \
		CMakeLists.txt || die

	# respect gentoo doc install directory
	sed -i \
		-e "s:share/doc/ceres:share/doc/${PF}:" \
		docs/source/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_EXAMPLES=OFF
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use gflags GFLAGS)
		$(cmake-utils_use lapack LAPACK)
		$(cmake-utils_use openmp OPENMP)
		$(cmake-utils_use protobuf PROTOBUF)
		$(cmake-utils_use schur SCHUR_SPECIALIZATIONS)
		$(cmake-utils_use cxsparse CXSPARSE)
		$(cmake-utils_use sparse SUITESPARSE)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README VERSION

	if use examples; then
		insinto /usr/share/doc/${PF}
		docompress -x /usr/share/doc/${PF}/examples
		doins -r examples data
	fi
}
