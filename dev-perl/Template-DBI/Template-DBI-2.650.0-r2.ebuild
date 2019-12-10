# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=REHSACK
DIST_VERSION=2.65
inherit perl-module

DESCRIPTION="DBI plugin for the Template Toolkit"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~ppc-aix ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/DBI-1.612
	>=dev-perl/Template-Toolkit-2.22"
DEPEND="${RDEPEND}
	test? (
		dev-perl/MLDBM
		>=dev-perl/SQL-Statement-1.28
	)"
PATCHES=(
	"${FILESDIR}/${PN}-2.65-no-dot-inc.patch"
)
