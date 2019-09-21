# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MY_P=elements-20001107-pre
DESCRIPTION="The elements database for dict"
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"
HOMEPAGE="http://www.dict.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND=">=app-text/dictd-1.5.5"

S=${WORKDIR}

src_install() {
	insinto /usr/lib/dict
	doins elements.dict.dz elements.index || die
}
