# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CHI/CHI-0.600.0.ebuild,v 1.1 2015/07/21 22:17:45 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JSWARTZ
MODULE_VERSION=0.60
inherit perl-module

DESCRIPTION="Unified cache handling interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Carp-Assert-0.200.0
	dev-perl/Class-Load
	dev-perl/Data-UUID
	dev-perl/Digest-JHash
	virtual/perl-Digest-MD5
	>=virtual/perl-File-Spec-0.800.0
	dev-perl/Hash-MoreUtils
	>=dev-perl/JSON-MaybeXS-1.3.3
	>=dev-perl/List-MoreUtils-0.130.0
	>=dev-perl/Log-Any-0.80.0
	>=dev-perl/Moo-1.3.0
	>=dev-perl/MooX-Types-MooseLike-0.230.0
	dev-perl/MooX-Types-MooseLike-Numeric
	virtual/perl-Storable
	dev-perl/String-RewritePrefix
	dev-perl/Task-Weaken
	>=dev-perl/Time-Duration-1.60.0
	>=dev-perl/Time-Duration-Parse-0.30.0
	virtual/perl-Time-HiRes
	>=dev-perl/Try-Tiny-0.50.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/TimeDate
		virtual/perl-Test-Simple
		dev-perl/Test-Class
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-Warn
	)
"

SRC_TEST="do parallel"
