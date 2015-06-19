# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Serializer/Data-Serializer-0.600.0.ebuild,v 1.2 2015/06/13 22:33:13 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=NEELY
MODULE_VERSION=0.60
inherit perl-module

DESCRIPTION="Modules that serialize data structures"
LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

RDEPEND="
	virtual/perl-AutoLoader
	virtual/perl-Data-Dumper
	virtual/perl-Digest-SHA
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	virtual/perl-File-Spec
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"
