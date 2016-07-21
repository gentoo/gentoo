# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JGOLDBERG
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="An XS implementation of the Levenshtein edit distance"

SLOT="0"
KEYWORDS="amd64 ia64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"
