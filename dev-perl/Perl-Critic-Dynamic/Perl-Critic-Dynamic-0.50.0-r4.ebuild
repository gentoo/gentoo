# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=THALJEF
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Base class for dynamic Policies"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 x86"

RDEPEND="dev-perl/Perl-Critic
	>=dev-perl/Devel-Symdump-2.08
	dev-perl/Readonly"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/CGI
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.05-test-cgi.patch" )
