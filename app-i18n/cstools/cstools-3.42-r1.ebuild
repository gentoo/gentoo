# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

MY_P="Cstools-${PV}"
DESCRIPTION="A charset conversion tool cstocs and two Perl modules for Czech language"
SRC_URI="https://www.adelton.com/perl/Cstools/${MY_P}.tar.gz"
HOMEPAGE="https://www.adelton.com/perl/Cstools/"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/MIME-tools"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

S="${WORKDIR}/${MY_P}"
