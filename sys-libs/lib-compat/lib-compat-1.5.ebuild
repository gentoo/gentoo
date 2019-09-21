# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Compatibility C++ library for very old programs"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="libstdc++"  # corresponding source code in gcc-2.95.3.tar.bz2
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~x86-linux"

src_install() {
	ABI=x86 dolib.so x86/libstdc++-libc6.2-2.so.3
}
