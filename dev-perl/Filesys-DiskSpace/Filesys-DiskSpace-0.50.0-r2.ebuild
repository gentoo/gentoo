# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FTASSIN
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl df"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_test() {
	#https://rt.cpan.org/Ticket/Display.html?id=108971
	perl_rm_files t/linux-ext2.t t/linux-vfat.t
	perl-module_src_test
}
