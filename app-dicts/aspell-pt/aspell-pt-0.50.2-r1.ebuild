# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

ASPELL_LANG="Portuguese"

inherit aspell-dict-r1

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_install() {
	aspell-dict-r1_src_install

	rm "${ED%/}"/usr/$(get_libdir)/aspell-0.60/pt_BR* || die
	rm "${ED%/}"/usr/$(get_libdir)/aspell-0.60/brazilian.alias || die
}
