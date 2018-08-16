# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	dobin multicd
	insinto /etc
	newins sample_multicdrc multicdrc
}
