# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Grove/XML-Grove-0.46_alpha-r2.ebuild,v 1.2 2014/04/30 20:06:47 zlogene Exp $

EAPI=5

inherit perl-module

MY_P="${P/_/}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Perl module providing a simple API to parsed XML instances"
HOMEPAGE="http://cpan.org/modules/by-module/XML/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/K/KM/KMACLEOD/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND=">=dev-perl/libxml-perl-0.07-r1"
RDEPEND="${DEPEND}"
