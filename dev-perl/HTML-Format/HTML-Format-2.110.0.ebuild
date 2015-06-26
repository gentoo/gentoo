# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Format/HTML-Format-2.110.0.ebuild,v 1.1 2015/06/26 21:25:01 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=NIGELM
MODULE_VERSION=2.11
inherit perl-module

DESCRIPTION="HTML Formatter"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	dev-perl/Font-AFM
	dev-perl/HTML-Tree
	virtual/perl-IO
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		dev-perl/File-Slurp
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST="do parallel"
