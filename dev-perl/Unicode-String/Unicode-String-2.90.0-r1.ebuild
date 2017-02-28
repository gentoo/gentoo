# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=GAAS
MODULE_VERSION=2.09
inherit perl-module

DESCRIPTION="String manipulation for Unicode strings"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-linux"
IUSE=""

RDEPEND=">=virtual/perl-MIME-Base64-2.11"
DEPEND="${RDEPEND}"
