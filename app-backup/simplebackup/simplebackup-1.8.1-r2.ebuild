# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="Cross-platform backup program"
HOMEPAGE="https://migas-sbackup.sourceforge.net/"
SRC_URI="mirror://sourceforge/migas-sbackup/${P}.tar.gz"
S="${WORKDIR}/${P}/unix"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sasl"

RDEPEND="
	dev-lang/perl
	sasl? ( dev-perl/Authen-SASL )
"

src_compile() {
	:;
}

src_install() {
	hprefixify simplebackup.pl
	newbin simplebackup.pl simplebackup
	dodoc ../unix_readme.txt
}
