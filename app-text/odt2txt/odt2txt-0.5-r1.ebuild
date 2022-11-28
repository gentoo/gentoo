# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A simple converter from OpenDocument Text to plain text"
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="https://github.com/dstosberg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc64 ~sparc x86"

RDEPEND="
	!app-office/unoconv
	sys-libs/zlib
	virtual/libiconv"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/groff"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}"/usr
	doman odt2txt.1
}
