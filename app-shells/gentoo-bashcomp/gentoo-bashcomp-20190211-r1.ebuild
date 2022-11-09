# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Gentoo-specific bash command-line completions (emerge, ebuild, equery, etc)"
HOMEPAGE="https://gitweb.gentoo.org/proj/gentoo-bashcomp.git/"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris"

src_install() {
	emake DESTDIR="${D}" install \
		completionsdir="$(get_bashcompdir)" \
		helpersdir="$(get_bashhelpersdir)" \
		compatdir="${EPREFIX}/etc/bash_completion.d"
}
