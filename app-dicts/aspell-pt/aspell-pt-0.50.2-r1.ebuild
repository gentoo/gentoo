# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

ASPELL_LANG="Portuguese"

inherit multilib aspell-dict

LICENSE="GPL-2"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE=""

src_install() {
	aspell-dict_src_install
	rm "${D}"/usr/$(get_libdir)/aspell-0.60/pt_BR*
	rm "${D}"/usr/$(get_libdir)/aspell-0.60/brazilian.alias
}
