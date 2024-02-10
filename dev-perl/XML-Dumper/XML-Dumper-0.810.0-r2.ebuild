# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIKEWONG
DIST_VERSION=0.81
inherit perl-module

DESCRIPTION="Perl module for dumping Perl objects from/to XML"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc sparc x86"

RDEPEND="
	>=dev-perl/XML-Parser-2.160.0
"
BDEPEND="${RDEPEND}
"
