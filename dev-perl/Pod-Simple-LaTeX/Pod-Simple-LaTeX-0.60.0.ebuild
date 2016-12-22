# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=JGOFF
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="format Pod as LaTeX"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Pod-Simple-0.10.0
"
DEPEND="${RDEPEND}"
