# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Algorithm-ClusterPoints/Algorithm-ClusterPoints-0.80.0.ebuild,v 1.1 2014/10/27 20:35:43 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=SALVA
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION='Find clusters inside a set of points'
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
