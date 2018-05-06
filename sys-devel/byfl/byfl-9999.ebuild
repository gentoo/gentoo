# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic llvm

if [ "${PV}" = "9999" ]; then
	LLVM_VERSION="6.0.0"
	LLVM_SLOT=6
	EGIT_REPO_URI="https://github.com/lanl/Byfl.git"
	inherit autotools git-r3
	KEYWORDS=""
else
	LLVM_VERSION="5.0.1"
	LLVM_SLOT=5
	MY_P="${P}-llvm-${LLVM_VERSION}"
	SRC_URI="https://github.com/lanl/Byfl/releases/download/v${MY_P#${PN}-}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux"
fi

DESCRIPTION="Compiler-based Application Analysis"
HOMEPAGE="https://github.com/lanl/Byfl"

SLOT="0"
LICENSE="BSD"
IUSE="hdf5 static-libs sqlite"

RDEPEND="
	>=sys-devel/clang-${LLVM_VERSION}:${LLVM_SLOT}
	>=sys-devel/llvm-${LLVM_VERSION}:${LLVM_SLOT}
	sys-devel/binutils:*
	dev-lang/perl:=
	dev-perl/Switch
	hdf5? ( sci-libs/hdf5[cxx] )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	[[ ${PV} = 9999 ]] && eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	use sqlite || export ac_cv_lib_sqlite3_sqlite3_errstr=no
	econf H5CXX=$(usex hdf5 h5c++ no)
}
