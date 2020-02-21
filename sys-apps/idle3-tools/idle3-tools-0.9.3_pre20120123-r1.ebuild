# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Set, get or disable the value of the idle3 timer found on WD HDDs"
HOMEPAGE="http://idle3-tools.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~conikost/files/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm x86"

PATCHES=( "${FILESDIR}"/makefile.patch )

src_compile() {
	emake CC="$(tc-getCC)"
}
