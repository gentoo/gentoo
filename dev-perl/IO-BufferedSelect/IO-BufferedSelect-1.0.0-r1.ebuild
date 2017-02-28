# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AFN
MODULE_VERSION=1.0
inherit perl-module

DESCRIPTION="Perl module that implements a line-buffered select interface"

SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/${PN}"
