# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils toolchain-funcs

MY_P="${PN}${PV//./}"

DESCRIPTION="Powerful Multilingual File Viewer"
HOMEPAGE="http://www.ff.iij4u.or.jp/~nrt/lv/"
SRC_URI="http://www.ff.iij4u.or.jp/~nrt/freeware/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="sys-libs/ncurses:0=
	!app-editors/levee"
DEPEND="${RDEPEND}
	dev-lang/perl"

S="${WORKDIR}/${MY_P}"

DOCS=(README hello.sample)
HTML_DOCS=(index.html relnote.html hello.sample.gif)

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-xz.diff
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-protos.patch
)

src_prepare() {
	default

	cd src
	eautoreconf
}

src_configure() {
	ECONF_SOURCE=src econf
}

src_compile() {
	emake CC="$(tc-getCC)"
}
