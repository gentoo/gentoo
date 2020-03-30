# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

MY_P="${P/_/}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Perl module providing a simple API to parsed XML instances"
HOMEPAGE="http://cpan.org/modules/by-module/XML/XML-Grove-0.46alpha.readme"
SRC_URI="mirror://cpan/authors/id/K/KM/KMACLEOD/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86"
IUSE=""

DEPEND=">=dev-perl/libxml-perl-0.07-r1"
RDEPEND="${DEPEND}"
