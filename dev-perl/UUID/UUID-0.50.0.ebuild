# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/UUID/UUID-0.50.0.ebuild,v 1.1 2014/12/05 21:01:52 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=LZAP
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION='Perl extension for using UUID interfaces as defined in e2fsprogs.'
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
"
RDEPEND="

"
SRC_TEST="do"
