# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Font-TTF/Font-TTF-1.20.0-r1.ebuild,v 1.2 2015/06/05 15:14:05 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MHOSKEN
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="module for compiling and altering fonts"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	virtual/perl-IO-Compress
	dev-perl/IO-String
	dev-perl/XML-Parser
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
