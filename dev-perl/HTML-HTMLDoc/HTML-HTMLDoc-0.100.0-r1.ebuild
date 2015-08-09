# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MFRANKL
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Perl interface to the htmldoc program for producing PDF-Files from HTML-Content"

SLOT="0"
KEYWORDS="amd64 ~arm ia64 ~ppc sparc x86"
IUSE=""

RDEPEND="app-text/htmldoc"
DEPEND="${RDEPEND}"

SRC_TEST="do"
