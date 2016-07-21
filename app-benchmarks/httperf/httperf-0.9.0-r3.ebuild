# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils toolchain-funcs

DESCRIPTION="A tool from HP for measuring web server performance"
HOMEPAGE="https://github.com/httperf/httperf"
SRC_URI="https://httperf.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-linux ~x64-macos"
IUSE="debug libressl"

RDEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	econf --bindir="${EPREFIX}"/usr/bin \
		$(use_enable debug)
}

src_compile() {
	emake CC="$(tc-getCC)" -j1
}
