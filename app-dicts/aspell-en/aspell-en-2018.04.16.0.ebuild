# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="English (US, British, Canadian)"
ASPELL_VERSION=6

inherit aspell-dict-r1 versionator

SRC_URI="mirror://gnu/aspell/dict/${ASPELL_SPELLANG}/${PN%-*}${ASPELL_VERSION}-${PN#*-}-$(replace_version_separator 3 '-').tar.bz2"

LICENSE="myspell-en_CA-KevinAtkinson public-domain Princeton Ispell"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
