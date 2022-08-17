# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ASPELL_LANG="Icelandic"

inherit aspell-dict-r1

LICENSE="GPL-2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_prepare() {
	default

	# Fix QA error '[..] not encoded with the UTF-8 encoding' by renaming file.
	sed -e 's/'$'\355''/Y/g' -i Makefile.pre || die
	mv ''$'\355''slenska.alias' Yslenska.alias || die
}
