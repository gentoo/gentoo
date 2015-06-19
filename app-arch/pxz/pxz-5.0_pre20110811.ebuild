# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pxz/pxz-5.0_pre20110811.ebuild,v 1.1 2011/08/11 20:59:44 chutzpah Exp $

EAPI="3"

inherit flag-o-matic

DESCRIPTION="Parallel implementation of the XZ compression utility"
HOMEPAGE="http://jnovy.fedorapeople.org/pxz/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}
	sys-devel/gcc[openmp]"

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
