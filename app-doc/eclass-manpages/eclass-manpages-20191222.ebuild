# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Collection of Gentoo eclass manpages"
HOMEPAGE="https://github.com/mgorny/eclass-to-manpage"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
# Keep the keywords stable. No need to change to ~arch.
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

BDEPEND="app-arch/xz-utils
	sys-apps/gawk"

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr"
}
