# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="glastree is a poor mans snapshot utility using hardlinks written in perl"
HOMEPAGE="http://www.igmus.org/code/"
SRC_URI="http://www.igmus.org/files/${P}.tar.gz"
DEPEND="dev-lang/perl
	dev-perl/Date-Calc"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
LICENSE="public-domain"

PATCHES=(
	"${FILESDIR}"/${PN}-posix-make.patch
)

src_compile() { :; }

src_install() {
	dodir /usr/share/man/man1
	emake INSTROOT="${ED}"/usr INSTMAN=share/man install
	dodoc README CHANGES THANKS TODO
}
