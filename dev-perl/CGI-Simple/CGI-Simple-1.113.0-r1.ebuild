# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI-Simple/CGI-Simple-1.113.0-r1.ebuild,v 1.2 2015/06/13 19:21:48 dilfridge Exp $

EAPI=5

MY_PN=CGI-Simple
MODULE_AUTHOR=ANDYA
MODULE_VERSION=1.113
inherit perl-module

DESCRIPTION="A Simple totally OO CGI interface that is CGI.pm compliant"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE="test"

RDEPEND=""
DEPEND="dev-perl/Module-Build
	test? (
		dev-perl/libwww-perl
		dev-perl/IO-stringy
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
