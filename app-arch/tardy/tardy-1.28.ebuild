# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/tardy/tardy-1.28.ebuild,v 1.5 2014/06/08 11:03:30 ago Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="A tar post-processor"
HOMEPAGE="http://tardy.sourceforge.net/"
SRC_URI="mirror://sourceforge/tardy/${P}.D001.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="app-arch/bzip2
	app-arch/xz-utils
	dev-libs/libexplain
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-libs/boost"

src_prepare() {
	sed -e 's/$(CXX) .* $(CXXFLAGS) -I./\0 -o $@/' \
		-e '/mv \(.*\)\.o $@/d' \
		-e '/@sleep 1/d' \
		-e 's#^\(install-man: $(mandir)/man1/tardy.1\).*#\1#' \
		-i Makefile.in || die

	epatch "${FILESDIR}"/${P}-test-utc.patch
	tc-export AR
}
