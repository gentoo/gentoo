# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="dio - Device I/O monitoring tool"
HOMEPAGE="https://github.com/donaldmcintosh/dio"
SRC_URI="https://github.com/donaldmcintosh/dio/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin dio
	doman dio.1
}
