# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-Detect/Encode-Detect-1.10.0-r1.ebuild,v 1.10 2015/06/13 22:44:54 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JGMYERS
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Encode::Detect - An Encode::Encoding subclass that detects the encoding of data"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="dev-perl/Module-Build
	virtual/perl-ExtUtils-CBuilder"

SRC_TEST=do
