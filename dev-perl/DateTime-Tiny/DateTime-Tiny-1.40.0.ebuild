# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Tiny/DateTime-Tiny-1.40.0.ebuild,v 1.1 2015/01/20 13:30:09 chainsaw Exp $

EAPI=5

MODULE_AUTHOR="ADAMK"
MODULE_VERSION="1.04"

inherit perl-module

DESCRIPTION="A date object, with as little code as possible"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
SRC_TEST=do
DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )"
