# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Userland for USB monitoring framework"
HOMEPAGE="https://people.redhat.com/zaitcev/linux/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_prepare() {
	default
	sed -e 's:-O2::g' -i "${S}"/Makefile || die
	tc-export CC
}

src_install() {
	dosbin ${PN}
	doman ${PN}.8
	dodoc README
}
