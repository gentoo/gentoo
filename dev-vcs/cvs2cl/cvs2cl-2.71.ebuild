# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="produces a GNU-style ChangeLog for CVS-controlled sources"
HOMEPAGE="https://www.red-bean.com/cvs2cl/"
SRC_URI="mirror://gentoo/${P}.pl.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="dev-lang/perl"

S=${WORKDIR}

maint_pkg_create() {
	set -x
	wget http://www.red-bean.com/cvs2cl/${PN}.pl
	mv ${PN}.pl ${P}.pl
	bzip2 ${P}.pl
	ls -l ${PWD}/${P}.pl.bz2
	set +x
}
#pkg_setup() { maint_pkg_create; }

src_install() {
	newbin ${P}.pl ${PN} || die
}
