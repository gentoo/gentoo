# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CKAISER
MODULE_VERSION=1.4

inherit perl-module

DESCRIPTION="Quick implementation of readline utilities for ttytter"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/TermReadKey"

SRC_TEST="do parallel"
