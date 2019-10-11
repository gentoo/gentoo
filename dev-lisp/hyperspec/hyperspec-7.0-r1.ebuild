# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV=${PV/./-}
MY_P=HyperSpec-${MY_PV}

DESCRIPTION="Common Lisp ANSI-standard Hyperspec"
HOMEPAGE="http://www.lispworks.com/reference/HyperSpec/"
SRC_URI="ftp://ftp.lispworks.com/pub/software_tools/reference/${MY_P}.tar.gz"
LICENSE="HyperSpec"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
DEPEND=""

S=${WORKDIR}/

src_install() {
	dodir /usr/share/doc/${P}
	cp -r HyperSpec* "${D}/usr/share/doc/${P}"
	dosym /usr/share/doc/${P} /usr/share/doc/hyperspec
}
