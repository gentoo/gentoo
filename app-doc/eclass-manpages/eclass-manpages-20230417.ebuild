# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Instructions to make a dist tarball:
# git clone https://github.com/projg2/eclass-to-manpage.git
# cd eclass-to-manpage
# make dist ECLASSDIR=~/g/eclass/

DESCRIPTION="Collection of Gentoo eclass manpages"
HOMEPAGE="https://github.com/projg2/eclass-to-manpage"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
# Keep the keywords stable. No need to change to ~arch.
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

BDEPEND="sys-apps/gawk"

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
}
