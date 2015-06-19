# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-Normalize/Unicode-Normalize-1.180.0.ebuild,v 1.1 2014/10/11 08:07:47 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SADAHIRO
MODULE_VERSION=1.18
inherit perl-module

DESCRIPTION="Unicode Normalization Forms"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
