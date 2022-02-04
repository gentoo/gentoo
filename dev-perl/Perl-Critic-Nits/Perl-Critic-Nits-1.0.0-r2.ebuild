# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KCOWGILL
DIST_VERSION=v${PV}

inherit perl-module

DESCRIPTION="policies of nits I like to pick"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-perl/Perl-Critic
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/Readonly )
"
