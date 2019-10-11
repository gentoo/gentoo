# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Belarusian"

inherit aspell-dict-r1

SRC_URI="mirror://gnu/aspell/dict/be/aspell5-be-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="classic"

S="${WORKDIR}/aspell5-be-${PV}"

src_prepare() {
	use classic || local PATCHES=( "${FILESDIR}"/aspell5-be-${PV}-official.patch )
	default
}
