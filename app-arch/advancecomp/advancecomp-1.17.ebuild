# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Recompress ZIP, PNG and MNG using deflate 7-Zip, considerably improving compression"
HOMEPAGE="http://advancemame.sourceforge.net/comp-readme.html"
SRC_URI="mirror://sourceforge/project/advancemame/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="mng png test"

RDEPEND="app-arch/bzip2
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? (
		app-text/tofrodos
		dev-util/valgrind
	)"

#RESTRICT="test" #282441

src_prepare() {
	epatch "${FILESDIR}"/${P}-bzip2-compile.patch
}

src_configure() {
	econf --enable-bzip2 \
		$(use_enable test valgrind)
}

src_install() {
	dobin advdef advzip

	if use png; then
		dobin advpng
		doman doc/advpng.1
	fi

	if use mng; then
		dobin advmng
		doman doc/advmng.1
	fi

	dodoc HISTORY AUTHORS README
	doman doc/advdef.1 doc/advzip.1
}
