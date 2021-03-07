# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=INGY
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Spiffy Perl Interface Framework For You"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}/${PN}-0.15-no-dot-inc.patch"
)
