# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="Manipulate and process PDB files using commonly available tools such as Perl, awk, etc"
HOMEPAGE="http://www.ks.uiuc.edu/Development/MDTools/pdbcat/"
SRC_URI="http://www.ks.uiuc.edu/Development/MDTools/${PN}/files/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-gcc.patch )
DOCS=( README )

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	cmake-utils_src_prepare
}
