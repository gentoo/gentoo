# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JGOULAH
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Automatically set update and create user id fields"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Class-Accessor-Grouped
	dev-perl/DBIx-Class-DynamicDefault
	dev-perl/DBIx-Class
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/DBD-SQLite )
"

PERL_RM_FILES=(
	t/02pod.t
	t/03podcoverage.t
)

PATCHES=(
	"${FILESDIR}/${PN}-0.11-no-dot-inc.patch"
)

# Parallel tests fail sometimes due to sharing a sqlite db path
# and recreating the same table
DIST_TEST="do"
