# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LINDNER
DIST_VERSION=0.8
inherit perl-module

DESCRIPTION="Cleans up HTML code for web browsers, not humans"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 ~s390 sparc x86"
IUSE=""

RDEPEND="!<app-text/html-xml-utils-5.3"
DEPEND="${RDEPEND}"
