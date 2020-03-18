# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Find deleted files in block devices"
HOMEPAGE="https://github.com/jbj/magicrescue"
SRC_URI="https://github.com/jbj/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="|| ( sys-libs/gdbm sys-libs/db:* )"
RDEPEND="${DEPEND}
	!net-mail/safecat"
# File collision with net-mail/safecat, #702004

PATCHES=( "${FILESDIR}/${P}-ldflags.patch"
		  "${FILESDIR}/${P}-remove_toolsdir.patch" )

src_prepare() {
	tc-export CC
	sed -i -e "\
			s:\$(INSTALLDIR)/share/magicrescue/recipes:\$(INSTALLDIR)/share/doc/${P}/recipes:;\
			s:\$(INSTALLDIR)/man/man1:\$(INSTALLDIR)/share/man/man1:;\
			s:\$(INSTALLDIR)/share/magicrescue/tools:\$(INSTALLDIR)/bin:" Makefile.in || die "could not mangle Makefile.in"
	default
}

src_configure() {
	# Not autotools, just looks like it sometimes
	./configure --prefix=/usr || die
}
