# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Template/HTML-Template-2.950.0.ebuild,v 1.2 2015/07/17 10:30:46 zlogene Exp $

EAPI=5

MODULE_AUTHOR=WONKO
MODULE_VERSION=2.95
inherit perl-module

DESCRIPTION="A Perl module to use HTML Templates"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="test"

DEPEND="test? ( dev-perl/CGI )"

SRC_TEST="do"
