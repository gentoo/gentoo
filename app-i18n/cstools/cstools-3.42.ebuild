# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-app

MY_P="Cstools-${PV}"
DESCRIPTION="A charset conversion tool cstocs and two Perl modules for Czech language"
SRC_URI="https://www.adelton.com/perl/Cstools/${MY_P}.tar.gz"
HOMEPAGE="https://www.adelton.com/perl/Cstools/"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-perl/MIME-tools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
