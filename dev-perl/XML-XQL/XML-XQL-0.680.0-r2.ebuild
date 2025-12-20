# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TJMATHER
DIST_VERSION=0.68
inherit perl-module

DESCRIPTION="A Perl module that allows you to perform XQL queries on XML trees"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86"

RDEPEND="
	>=dev-perl/libxml-perl-0.70.0
	>=dev-perl/XML-DOM-1.390.0
	>=dev-perl/Parse-Yapp-1.50.0
	dev-perl/libwww-perl
	>=dev-perl/Date-Manip-5.400.0
"
BDEPEND="${RDEPEND}
"
