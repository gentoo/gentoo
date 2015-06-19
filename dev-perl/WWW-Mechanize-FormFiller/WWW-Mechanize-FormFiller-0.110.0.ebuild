# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Mechanize-FormFiller/WWW-Mechanize-FormFiller-0.110.0.ebuild,v 1.1 2015/03/11 16:18:50 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=CORION
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Framework to automate HTML forms"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND="dev-perl/Data-Random
	|| (
		( dev-perl/libwww-perl dev-perl/HTML-Form )
		dev-perl/libwww-perl
	)"
RDEPEND="${DEPEND}"

SRC_TEST="do"
