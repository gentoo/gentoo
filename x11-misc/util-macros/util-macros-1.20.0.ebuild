# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="X.Org autotools utility macros"
HOMEPAGE="https://www.x.org/wiki/ https://gitlab.freedesktop.org/xorg/util/macros"
SRC_URI="https://www.x.org/releases/individual/util/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# there is nothing to compile for this package, all its contents are produced by
# configure. the only make job that matters is make install
src_compile() { :; }
