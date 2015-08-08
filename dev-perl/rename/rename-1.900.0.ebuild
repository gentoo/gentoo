# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PEDERST
MODULE_VERSION=1.9
inherit perl-module

DESCRIPTION="A filename renaming utility based on perl regular expression"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	perl-module_src_install

	mv -vf "${D}"/usr/bin/rename "${D}"/usr/bin/perl-rename || die
	mv -vf "${D}"/usr/share/man/man1/rename.1 "${D}"/usr/share/man/man1/perl-rename.1 || die
}
