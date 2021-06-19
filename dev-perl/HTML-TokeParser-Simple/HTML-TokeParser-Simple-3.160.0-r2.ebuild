# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OVID
DIST_VERSION=3.16
inherit perl-module

DESCRIPTION="Easy to use HTML::TokeParser interface"

SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-perl/HTML-Parser-3.25"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-Test-Simple
	dev-perl/Sub-Override
"
