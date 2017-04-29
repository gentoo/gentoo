# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_STANDARD=77

inherit cmake-utils fortran-2

MY_PN=SuperLU

if [[ ${PV} != *9999* ]]; then
	inherit versionator
	SRC_URI="http://crd.lbl.gov/~xiaoye/SuperLU//${PN}_${PV}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
	SLOT="0/$(get_major_version)"
	S="${WORKDIR}/SuperLU_${PV}"
else
	inherit git-r3
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI=( "git://github.com/xiaoyeli/superlu" )
	SLOT="0/9999"
	KEYWORDS="~hppa"
fi

DESCRIPTION="Sparse LU factorization library"
HOMEPAGE="http://crd.lbl.gov/~xiaoye/SuperLU/"
LICENSE="BSD"

IUSE="doc examples test"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( app-shells/tcsh )"

PATCHES=(
	"${FILESDIR}"/${P}-no-implicits.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
)

S="${WORKDIR}/${MY_PN}_${PV}"

src_prepare() {
	default
	# respect user's CFLAGS
	sed -i -e 's/O3//' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs+=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/superlu"
		-DBUILD_SHARED_LIBS=ON
		-Denable_blaslib=OFF
		-Denable_tests=$(usex test)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r DOC/html
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r EXAMPLE FORTRAN
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
