# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/multicd/multicd-1.7.5-r1.ebuild,v 1.1 2008/06/15 15:39:33 drac Exp $

DESCRIPTION="Tool for making direct copies of your files to multiple cd's"
HOMEPAGE="http://danborn.net/multicd/"
SRC_URI="http://danborn.net/multicd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.6
	virtual/cdrtools"

src_install() {
	dobin multicd || die "dobin failed."
	insinto /etc
	newins sample_multicdrc multicdrc || die "newins failed."
}
