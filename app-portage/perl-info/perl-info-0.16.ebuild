# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool to gather relevant perl data useful for bugreport; 'emerge --info' for perl"
HOMEPAGE="https://www.gentoo.org/proj/en/perl/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	https://dev.gentoo.org/~tove/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~ia64 ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	virtual/perl-Term-ANSIColor
	>=dev-perl/PortageXS-0.02.04"

S=${WORKDIR}

src_install() {
	dobin ${PN}
}
