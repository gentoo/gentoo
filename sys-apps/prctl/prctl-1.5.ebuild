# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/prctl/prctl-1.5.ebuild,v 1.7 2013/01/27 23:28:09 mattst88 Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Tool to query and modify process behavior"
HOMEPAGE="http://sourceforge.net/projects/prctl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ia64"
IUSE=""

RDEPEND=""
DEPEND="sys-apps/groff"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin prctl
	doman prctl.1
	dodoc ChangeLog
}
