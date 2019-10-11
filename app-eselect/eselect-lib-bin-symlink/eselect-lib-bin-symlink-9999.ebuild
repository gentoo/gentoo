# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"
AUTOTOOLS_AUTORECONF=1
inherit git-r3
#endif

inherit autotools-utils

DESCRIPTION="An eselect library to manage executable symlinks"
HOMEPAGE="https://bitbucket.org/mgorny/eselect-lib-bin-symlink/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect"
#if LIVE

KEYWORDS=
SRC_URI=
#endif
