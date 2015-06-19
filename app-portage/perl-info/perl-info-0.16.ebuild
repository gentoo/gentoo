# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/perl-info/perl-info-0.16.ebuild,v 1.7 2012/03/18 16:00:53 armin76 Exp $

DESCRIPTION="Tool to gather relevant perl data useful for bugreports; 'emerge --info' for perl"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.gentoo.org/~tove/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl
	virtual/perl-Term-ANSIColor
	>=dev-perl/PortageXS-0.02.04"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN} || die
}
