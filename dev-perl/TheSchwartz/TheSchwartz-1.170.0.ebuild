# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AKIYM
DIST_VERSION=1.17
inherit perl-module

DESCRIPTION="Reliable job queue"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"

RDEPEND="
	dev-perl/Class-Accessor
	>=dev-perl/Data-ObjectDriver-0.40.0
	virtual/perl-Digest-MD5
	virtual/perl-Storable
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
"

# Parallel tests fail due to database ordering issues
DIST_TEST="do"
