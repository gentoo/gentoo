# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-Session/Apache-Session-1.900.0-r1.ebuild,v 1.2 2015/06/13 19:25:48 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=1.90
inherit perl-module

DESCRIPTION="Perl module for Apache::Session"

SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Storable"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"
#	test? (
#		dev-perl/Test-Deep
#		dev-perl/Test-Exception
#	)
