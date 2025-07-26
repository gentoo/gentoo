# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILMARI
DIST_VERSION=0.02003
inherit perl-module

DESCRIPTION="Auto-create NetAddr::IP objects from columns"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/NetAddr-IP
	>=dev-perl/DBIx-Class-0.81.70
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/DBD-SQLite )
"

PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod-t.
	t/style-notabs.t
)

PATCHES=(
	"${FILESDIR}/${PN}-0.02003-no-dot-inc.patch"
)
