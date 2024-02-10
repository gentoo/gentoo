# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JSTOWE
DIST_VERSION=0.48
inherit perl-module

DESCRIPTION="A Perl module to parse XSL Transformational sheets"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86"

RDEPEND="
	>=dev-perl/XML-Parser-2.290.0
	>=dev-perl/XML-DOM-1.250.0
	>=dev-perl/libwww-perl-5.480.0
"
BDEPEND="${RDEPEND}
"
