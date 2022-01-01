# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MHOSKEN
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="module for compiling and altering fonts"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="
	virtual/perl-IO-Compress
	dev-perl/IO-String
	dev-perl/XML-Parser
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
