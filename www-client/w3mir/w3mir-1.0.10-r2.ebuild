# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-app

DESCRIPTION="w3mir is a all purpose HTTP copying and mirroring tool"
SRC_URI="http://langfeldt.net/w3mir/${P}.tar.gz"
HOMEPAGE="http://langfeldt.net/w3mir/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 ppc ~sparc x86 ~arm-linux ~x86-linux"

DEPEND="${DEPEND}
	>=dev-perl/URI-1.0.9
	>=dev-perl/libwww-perl-5.64-r1
	>=virtual/perl-MIME-Base64-2.12"

src_prepare() {

	epatch "${FILESDIR}/${P}-cwd.diff"
}
