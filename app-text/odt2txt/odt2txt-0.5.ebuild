# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A simple converter from OpenDocument Text to plain text"
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="https://github.com/dstosberg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc64 ~sparc x86 ~x86-macos"
IUSE=""

RDEPEND="
	!app-office/unoconv
	sys-libs/zlib
	virtual/libiconv
"
DEPEND="${RDEPEND}
	sys-apps/groff
"
PATCHES="${FILESDIR}/${P}-darwin_iconv.patch"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr
	doman odt2txt.1
}
