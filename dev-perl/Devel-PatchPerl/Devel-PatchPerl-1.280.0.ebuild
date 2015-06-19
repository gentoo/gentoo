# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-PatchPerl/Devel-PatchPerl-1.280.0.ebuild,v 1.2 2015/06/13 18:49:29 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=BINGOS
MODULE_VERSION=1.28
inherit perl-module

DESCRIPTION="Patch perl source a la Devel::PPPort's buildperl.pl"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/File-pushd-1.0.0
	virtual/perl-IO
	virtual/perl-MIME-Base64
	dev-perl/Module-Pluggable
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST="do parallel"
