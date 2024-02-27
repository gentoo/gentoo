# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Convert a .rpm file to a .tar.gz archive"
HOMEPAGE="http://www.slackware.com/config/packages.php"
SRC_URI="mirror://gentoo/${P}.tar.xz
	https://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-alternatives/cpio"

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}"/usr install
	einstalldocs
}
