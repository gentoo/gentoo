# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GBROWN
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="a simple, pure Perl dialog for printing PostScript data in GTK+ applications"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cups"

RDEPEND="cups? ( dev-perl/Net-CUPS )
	dev-perl/gtk2-perl
	>=dev-perl/Locale-gettext-1.04"
DEPEND="${RDEPEND}"

#SRC_TEST="do"
