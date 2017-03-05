# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JENSL
DIST_VERSION=0.5
inherit perl-module

DESCRIPTION="File::DirWalk - walk through a directory tree and run own code"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Carp-1.80.0
	>=virtual/perl-File-Spec-3.250.100
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	test? (
		>=dev-perl/Test-Exception-0.270.0
		>=virtual/perl-Test-Simple-0.720.0
	)
"

PATCHES=(
	"${FILESDIR}/${P}-qw-list.patch"
)
