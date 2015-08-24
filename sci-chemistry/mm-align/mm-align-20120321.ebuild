# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils fortran-2

DESCRIPTION="Protein Complex Structural Alignment"
HOMEPAGE="http://zhanglab.ccmb.med.umich.edu/MM-align/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/MM-align-${PV}.tar.xz"

SLOT="0"
LICENSE="tm-align"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
}
