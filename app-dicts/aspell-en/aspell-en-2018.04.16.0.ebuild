# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ASPELL_LANG="English (US, British, Canadian)"
ASPELL_VERSION=6
inherit aspell-dict-r1

SRC_URI="mirror://gnu/aspell/dict/${ASPELL_SPELLANG}/${PN%-*}${ASPELL_VERSION}-${PN#*-}-$(ver_rs 3 '-').tar.bz2"

LICENSE="myspell-en_CA-KevinAtkinson public-domain Princeton Ispell"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
