# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JSTENZEL
MODULE_VERSION=1.11
inherit perl-module

DESCRIPTION="This module is a simple supplement to other option handling modules"

SLOT="0"
LICENSE="|| ( Artistic Artistic-2 )" # Artistic+
KEYWORDS="amd64 ia64 ppc ~ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
