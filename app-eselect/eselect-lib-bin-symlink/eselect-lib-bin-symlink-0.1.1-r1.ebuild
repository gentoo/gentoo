# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An eselect library to manage executable symlinks"
HOMEPAGE="https://github.com/projg2/eselect-lib-bin-symlink/"
SRC_URI="https://github.com/projg2/eselect-lib-bin-symlink/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="app-admin/eselect"
