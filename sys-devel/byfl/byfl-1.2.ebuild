# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/byfl/byfl-1.2.ebuild,v 1.1 2015/04/03 19:46:52 ottxor Exp $

EAPI=5

inherit autotools-utils flag-o-matic

if [ "${PV}" = "9999" ]; then
	LLVM_VERSION="3.6"
	EGIT_REPO_URI="git://github.com/losalamos/${PN^b}.git http://github.com/losalamos/${PN}.git"
	inherit git-2
	KEYWORDS=""
	AUTOTOOLS_AUTORECONF=1
else
	LLVM_VERSION="3.5.1"
	MY_P="${P}-llvm-${LLVM_VERSION}"
	SRC_URI="https://github.com/losalamos/Byfl/releases/download/v${MY_P#${PN}-}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~amd64-linux"
fi

DESCRIPTION="Compiler-based Application Analysis"
HOMEPAGE="https://github.com/losalamos/Byfl"

SLOT="0"
LICENSE="BSD"
IUSE="dragonegg hdf5 static-libs sqlite"

RDEPEND="dragonegg? ( >=sys-devel/dragonegg-${LLVM_VERSION} )
	>=sys-devel/clang-${LLVM_VERSION}
	>=sys-devel/llvm-${LLVM_VERSION}
	sys-devel/binutils
	dev-lang/perl:=
	dev-perl/Switch
	hdf5? ( sci-libs/hdf5[cxx] )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

src_configure() {
	append-cxxflags -std=c++11
	use dragonegg || export ax_cv_file_dragonegg_so=no
	use sqlite || export ac_cv_lib_sqlite3_sqlite3_errstr=no
	autotools-utils_src_configure H5CXX=$(usex hdf5 h5c++ no)
}
