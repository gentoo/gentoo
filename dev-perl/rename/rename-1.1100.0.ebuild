# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PEDERST
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="A filename renaming utility based on perl regular expression"

HOMEPAGE="https://metacpan.org/source/PEDERST/rename-1.11"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	perl-module_src_install

	mv -vf "${D}"/usr/bin/rename "${D}"/usr/bin/perl-rename || die
	mv -vf "${D}"/usr/share/man/man1/rename.1 "${D}"/usr/share/man/man1/perl-rename.1 || die
}
