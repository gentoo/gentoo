# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"

inherit flag-o-matic

DESCRIPTION="Parallel implementation of the XZ compression utility"
HOMEPAGE="https://jnovy.fedorapeople.org/pxz/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE=""

RDEPEND="app-arch/xz-utils"
DEPEND="${RDEPEND}
	sys-devel/gcc[openmp]"

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
