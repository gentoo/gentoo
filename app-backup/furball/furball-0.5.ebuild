# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/furball/furball-0.5.ebuild,v 1.4 2013/03/03 12:08:12 ago Exp $

EAPI=4

DESCRIPTION="A handy backup script utilizing tar"
SRC_URI="http://www.claws-and-paws.com/software/${PN}/${P}.tgz"
HOMEPAGE="http://www.claws-and-paws.com/software/furball/index.shtml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""
RDEPEND="dev-lang/perl
	app-arch/tar"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README NEWS THANKS
}
