# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools toolchain-funcs

MY_P="${PN}${PV//./}"

DESCRIPTION="Powerful Multilingual File Viewer"
#HOMEPAGE="http://www.ff.iij4u.or.jp/~nrt/lv/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="!app-editors/levee
	sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	dev-lang/perl"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-headers.patch
	"${FILESDIR}"/${PN}-tinfo.patch
	"${FILESDIR}"/${PN}-xz.patch
)
DOCS=( README hello.sample )
HTML_DOCS=( index.html relnote.html hello.sample.gif )

src_prepare() {
	default

	cd src
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	ECONF_SOURCE=src econf
}

src_compile() {
	emake CC="$(tc-getCC)"
}
