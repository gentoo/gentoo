# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CGI-Ajax/CGI-Ajax-0.707.0.ebuild,v 1.2 2015/06/13 17:12:37 dilfridge Exp $

EAPI=5

MODULE_VERSION=0.707
MODULE_AUTHOR=BPEDERSE
inherit perl-module

DESCRIPTION="a perl-specific system for writing Asynchronous web applications"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/CGI
	dev-perl/Class-Accessor
"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
