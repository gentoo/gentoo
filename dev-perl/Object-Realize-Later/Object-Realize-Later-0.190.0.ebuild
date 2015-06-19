# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Object-Realize-Later/Object-Realize-Later-0.190.0.ebuild,v 1.1 2015/02/27 23:58:57 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Delayed creation of objects"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Pod-1.0.0
	)
"

SRC_TEST=do
