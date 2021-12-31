# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TJMATHER
MODULE_VERSION=0.68
inherit perl-module

DESCRIPTION="A Perl module that allows you to perform XQL queries on XML trees"

SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/libxml-perl-0.07-r1
	>=dev-perl/XML-DOM-1.39-r1
	>=dev-perl/Parse-Yapp-1.05
	dev-perl/libwww-perl
	>=dev-perl/Date-Manip-5.40-r1"
DEPEND="${RDEPEND}"
