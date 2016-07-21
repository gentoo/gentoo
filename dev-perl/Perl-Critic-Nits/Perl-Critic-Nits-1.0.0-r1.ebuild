# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="KCOWGILL"
MY_P="${PN}-v${PV}"

inherit perl-module

DESCRIPTION="policies of nits I like to pick"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

DEPEND="test? ( dev-perl/Perl-Critic
		dev-perl/Readonly )"
RDEPEND="dev-perl/Perl-Critic"

SRC_URI="mirror://cpan/authors/id/K/KC/KCOWGILL/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

SRC_TEST="do parallel"
