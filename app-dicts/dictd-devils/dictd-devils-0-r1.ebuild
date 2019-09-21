# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

MY_P=devils-dict-pre
S=${WORKDIR}
DESCRIPTION="The Devil's Dictionary for dict"
HOMEPAGE="http://www.dict.org/"
SRC_URI="ftp://ftp.dict.org/pub/dict/pre/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND=">=app-text/dictd-1.5.5"

src_install() {
	insinto /usr/lib/dict
	doins devils.dict.dz devils.index || die
}
