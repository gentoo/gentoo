# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/dio/dio-1.5.2.ebuild,v 1.1 2015/03/16 04:47:07 dlan Exp $

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="dio - Device I/O monitoring tool"
HOMEPAGE="https://github.com/donaldmcintosh/dio"
SRC_URI="https://github.com/donaldmcintosh/dio/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin dio
	doman dio.1
}
