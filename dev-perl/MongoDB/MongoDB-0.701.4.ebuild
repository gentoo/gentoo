# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
MODULE_AUTHOR="FRIEDO"

inherit perl-module

DESCRIPTION="A Mongo Driver for Perl"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-perl/DateTime
	dev-perl/Tie-IxHash
	dev-perl/Data-Types
	dev-perl/DateTime-Tiny
	dev-perl/Class-Method-Modifiers
	dev-perl/boolean
	dev-perl/Moose
	dev-perl/File-Slurp
	dev-perl/Try-Tiny
	dev-perl/Module-Install
	dev-perl/JSON
	virtual/perl-ExtUtils-MakeMaker"

src_prepare() {
	epatch "${FILESDIR}"/gridfs-perl-patch.diff
}
