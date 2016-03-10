# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"
MODULE_AUTHOR=MDOOTSON
MODULE_VERSION=0.9902
inherit wxwidgets perl-module

DESCRIPTION="Perl bindings for wxGTK"
HOMEPAGE="http://wxperl.sourceforge.net/"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-perl/Alien-wxWidgets-0.25
	>=virtual/perl-File-Spec-0.82"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-ParseXS-0.22.03
	>=dev-perl/ExtUtils-XSpp-0.160.200"

MAKEOPTS="${MAKEOPTS} -j1"
