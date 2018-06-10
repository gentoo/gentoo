# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit autotools eutils toolchain-funcs

MY_P="${PN}${PV//./}"

DESCRIPTION="Powerful Multilingual File Viewer"
#HOMEPAGE="http://www.ff.iij4u.or.jp/~nrt/lv/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="!app-editors/levee
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	dev-lang/perl"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gentoo.patch
	epatch "${FILESDIR}"/${PN}-headers.patch
	epatch "${FILESDIR}"/${PN}-tinfo.patch
	epatch "${FILESDIR}"/${PN}-xz.patch

	cd "${S}"/src
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	ECONF_SOURCE=src econf
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README hello.sample
	dohtml index.html relnote.html hello.sample.gif
}
