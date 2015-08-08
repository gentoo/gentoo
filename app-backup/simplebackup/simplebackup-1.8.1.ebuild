# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Cross-platform backup program"
HOMEPAGE="http://migas-sbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/migas-sbackup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sasl"

DEPEND=""
RDEPEND="dev-lang/perl
	sasl? ( dev-perl/Authen-SASL )"

S=${WORKDIR}/${P}/unix

src_compile() {
	return;
}

src_install() {
	newbin simplebackup.pl simplebackup
	dodoc ../unix_readme.txt
}
