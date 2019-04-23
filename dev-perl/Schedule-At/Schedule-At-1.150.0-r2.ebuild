# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JOSERODR
DIST_VERSION=1.15
inherit perl-module

DESCRIPTION="OS independent interface to the Unix 'at' command"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="sys-process/at"
DEPEND="${RDEPEND}"
