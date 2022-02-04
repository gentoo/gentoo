# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Fails in parallel
# bug #707888
DIST_TEST="do"
inherit perl-module

MY_P="Cstools-${PV}"
DESCRIPTION="A charset conversion tool cstocs and two Perl modules for Czech language"
SRC_URI="https://www.adelton.com/perl/Cstools/${MY_P}.tar.gz"
HOMEPAGE="https://www.adelton.com/perl/Cstools/"
S="${WORKDIR}/${MY_P}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-perl/MIME-tools"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
