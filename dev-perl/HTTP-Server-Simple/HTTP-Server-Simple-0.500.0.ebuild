# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-Server-Simple/HTTP-Server-Simple-0.500.0.ebuild,v 1.1 2015/07/04 11:15:17 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=FALCONE
MODULE_VERSION=0.50
inherit perl-module eutils

DESCRIPTION="Lightweight HTTP Server"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	dev-perl/CGI
	>=virtual/perl-Socket-1.940.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do parallel"
