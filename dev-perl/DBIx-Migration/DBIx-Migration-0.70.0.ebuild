# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBIx-Migration/DBIx-Migration-0.70.0.ebuild,v 1.3 2015/06/13 21:45:18 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DANIEL
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Seamless DB schema up- and downgrades"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/File-Slurp
	virtual/perl-File-Spec
	dev-perl/DBI
	dev-perl/Class-Accessor"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/DBD-SQLite
	)"

SRC_TEST=do
