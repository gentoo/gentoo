# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TJENNESS
MODULE_VERSION=0.61
inherit perl-module

DESCRIPTION="Convert Pod data to formatted LaTeX"

LICENSE="|| ( GPL-1+ Artistic )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="
	virtual/perl-Pod-Parser
	virtual/perl-if
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"

SRC_TEST="do"
