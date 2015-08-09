# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit multilib toolchain-funcs

DESCRIPTION="reading, writing, and editing of XLS (BIFF8 format) files using C++"
HOMEPAGE="http://www.codeproject.com/KB/office/ExcelFormat.aspx"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="CPOL"
IUSE=""

S="${WORKDIR}"/libExcelFormat

src_prepare() {
	tc-export CXX
}

src_install() {
	insinto /usr/include
	doins *.h* || die

	dolib.so libExcelFormat.so* || die
}
