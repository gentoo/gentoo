# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="automatic mail answering program"
HOMEPAGE="http://vacation.sourceforge.net/"
SRC_URI="mirror://sourceforge/vacation/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~x86"
SLOT="0"

RDEPEND="!mail-mta/sendmail
	sys-libs/gdbm
	virtual/mta"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -i -e "s:install -s -m:install -m:" -e "s:-Xlinker:${LDFLAGS} -Xlinker:" Makefile || die "sed failed!"
}

src_compile () {
	emake CFLAGS="${CFLAGS} -DMAIN"
}

src_install () {
	emake BINDIR="${D}/usr/bin" MANDIR="${D}/usr/share/man/man" install
}
