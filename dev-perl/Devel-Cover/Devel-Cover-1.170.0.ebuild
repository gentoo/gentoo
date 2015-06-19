# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Cover/Devel-Cover-1.170.0.ebuild,v 1.1 2015/03/27 16:30:57 chainsaw Exp $

EAPI=5
MODULE_AUTHOR=PJCJ
MODULE_VERSION=1.17
inherit perl-module

DESCRIPTION='Code coverage metrics for Perl'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-Storable
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"
SRC_TEST="do parallel"
