# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/cstools/cstools-3.42.ebuild,v 1.8 2013/04/09 18:26:49 ago Exp $

EAPI=5

inherit perl-app

MY_P="Cstools-${PV}"
DESCRIPTION="A charset conversion tool cstocs and two convenience Perl modules for Czech language"
SRC_URI="http://www.adelton.com/perl/Cstools/${MY_P}.tar.gz"
HOMEPAGE="http://www.adelton.com/perl/Cstools/"
SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-perl/MIME-tools"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
