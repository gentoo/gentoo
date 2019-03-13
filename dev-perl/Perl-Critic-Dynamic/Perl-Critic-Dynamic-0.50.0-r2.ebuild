# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=THALJEF
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Base class for dynamic Policies"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND="dev-perl/Perl-Critic
	>=dev-perl/Devel-Symdump-2.08
	dev-perl/Readonly"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

PATCHES=( "${FILESDIR}/${PN}-0.05-test-cgi.patch" )
