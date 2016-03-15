# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils flag-o-matic

if [ "${PV}" = "9999" ]; then
	LLVM_VERSION="3.7.0"
	# Switch to ^b when we switch to EAPI=6.
	EGIT_REPO_URI="git://github.com/losalamos/B${PN:1}.git https://github.com/losalamos/${PN}.git"
	inherit git-2
	KEYWORDS=""
	AUTOTOOLS_AUTORECONF=1
else
	LLVM_VERSION="3.7.0"
	MY_P="${P}-llvm-${LLVM_VERSION}"
	SRC_URI="https://github.com/losalamos/Byfl/releases/download/v${MY_P#${PN}-}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Compiler-based Application Analysis"
HOMEPAGE="https://github.com/losalamos/Byfl"

SLOT="0"
LICENSE="BSD"
IUSE="hdf5 static-libs sqlite"

RDEPEND="
	>=sys-devel/clang-${LLVM_VERSION}
	>=sys-devel/llvm-${LLVM_VERSION}
	sys-devel/binutils:*
	dev-lang/perl:=
	dev-perl/Switch
	hdf5? ( sci-libs/hdf5[cxx] )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

src_configure() {
	append-cxxflags -std=c++11
	use sqlite || export ac_cv_lib_sqlite3_sqlite3_errstr=no
	autotools-utils_src_configure H5CXX=$(usex hdf5 h5c++ no)
}
