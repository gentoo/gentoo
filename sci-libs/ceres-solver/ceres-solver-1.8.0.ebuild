# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils eutils multilib

DESCRIPTION="Nonlinear least-squares minimizer"
HOMEPAGE="https://code.google.com/p/ceres-solver/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cxsparse doc examples gflags lapack openmp protobuf +schur sparse static-libs test"
REQUIRED_USE="test? ( gflags ) sparse? ( lapack )"

RDEPEND="
	dev-cpp/glog[gflags?]
	cxsparse? ( sci-libs/cxsparse )
	lapack? ( virtual/lapack )
	protobuf? ( dev-libs/protobuf )
	sparse? (
		sci-libs/amd
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod
		sci-libs/colamd
		sci-libs/spqr )"

DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	lapack? ( virtual/pkgconfig )
	doc? ( dev-python/sphinx )
	${PYTHON_DEPS}"

src_prepare() {
	# prefix love
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		cmake/*.cmake || die

	# remove Werror and
	sed -i \
		-e 's/-Werror//g' \
		CMakeLists.txt || die

	# respect gentoo doc dir
	sed -i \
		-e "s:share/doc/ceres:share/doc/${PF}:" \
		docs/source/CMakeLists.txt || die
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
