# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FTASSIN
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Disk space information"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

src_test() {
	#https://rt.cpan.org/Ticket/Display.html?id=108971
	perl_rm_files t/linux-ext2.t t/linux-vfat.t
	perl-module_src_test
}
