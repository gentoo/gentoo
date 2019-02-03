# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="mecab-skkserv is a Kana-Kanji conversion server using MeCab"
HOMEPAGE="http://chasen.org/~taku/software/mecab-skkserv/"
SRC_URI="http://chasen.org/~taku/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2 ipadic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/mecab"
RDEPEND="${DEPEND}
	sys-apps/xinetd"

PATCHES=(
	"${FILESDIR}"/${PN}-cflags.patch
	"${FILESDIR}"/${PN}-dicrc.patch
	"${FILESDIR}"/${PN}-getopt.patch
)
HTML_DOCS=( index.html ${PN}.css )

src_prepare() {
	sed -i "/^dictdir/s:lib:$(get_libdir):" Makefile.am

	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/${PN}.xinetd ${PN}
}
