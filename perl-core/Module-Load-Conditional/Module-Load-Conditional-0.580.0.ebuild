# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Module-Load-Conditional/Module-Load-Conditional-0.580.0.ebuild,v 1.3 2015/06/07 22:39:28 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BINGOS
MODULE_VERSION=0.58
inherit perl-module

DESCRIPTION="Looking up module information / loading at runtime"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=virtual/perl-Module-Load-0.12
	>=virtual/perl-Module-CoreList-0.22
	>=virtual/perl-Module-Metadata-1.0.5
	virtual/perl-Locale-Maketext-Simple
	virtual/perl-Params-Check
	virtual/perl-version
"
DEPEND="${RDEPEND}"

SRC_TEST=do
