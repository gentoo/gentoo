# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="A small perl script utilizing tar"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://www.claws-and-paws.com/software/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
RDEPEND="dev-lang/perl
	app-arch/tar"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README NEWS THANKS
}
