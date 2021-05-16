# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CKAISER
DIST_VERSION=1.4

inherit perl-module

DESCRIPTION="Quick implementation of readline utilities for ttytter"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${PN}-1.4-nointeractive.patch" )
RDEPEND="dev-perl/TermReadKey"
