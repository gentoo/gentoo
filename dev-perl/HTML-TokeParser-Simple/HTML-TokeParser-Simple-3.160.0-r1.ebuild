# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-TokeParser-Simple/HTML-TokeParser-Simple-3.160.0-r1.ebuild,v 1.3 2015/06/13 22:51:13 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=3.16
inherit perl-module

DESCRIPTION="A bare-bones HTML parser, similar to HTML::Parser, but with a couple important distinctions"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-perl/HTML-Parser-3.25"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-Test-Simple
	dev-perl/Sub-Override"

SRC_TEST="do"
