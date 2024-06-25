# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEDERST
DIST_VERSION=1.14
inherit perl-module

DESCRIPTION="Filename renaming utility based on perl regular expression"

SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	perl-module_src_install

	mv -vf "${ED}"/usr/bin/rename "${ED}"/usr/bin/perl-rename || die
	mv -vf "${ED}"/usr/share/man/man1/rename.1 "${ED}"/usr/share/man/man1/perl-rename.1 || die
}
