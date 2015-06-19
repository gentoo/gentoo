# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/most/most-5.0.0a-r1.ebuild,v 1.6 2015/05/27 13:50:28 zlogene Exp $

EAPI=5

inherit eutils

DESCRIPTION="Paging program that displays, one windowful at a time, the contents of a file"
HOMEPAGE="ftp://space.mit.edu/pub/davis/most"
SRC_URI="ftp://space.mit.edu/pub/davis/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~mips ppc sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=sys-libs/slang-2.1.3"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.0.0a-no-explicit-termcap.patch
	epatch "${FILESDIR}"/${PN}-5.0.0a-donot-hardcode-path.patch
	sed -i -e 's:$(INSTALL) -s:$(INSTALL):' src/Makefile.in || die
	export MAKEOPTS+=" -j1"
}

src_configure() {
	unset ARCH
	econf
}

src_install() {
	emake DESTDIR="${D}" DOC_DIR="${EPREFIX}/usr/share/doc/${PF}" \
		install
}
