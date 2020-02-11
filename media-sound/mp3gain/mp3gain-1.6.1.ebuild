# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

MY_P="${P//./_}"

DESCRIPTION="A program to analyze and adjust MP3 files to same volume"
HOMEPAGE="http://mp3gain.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	app-arch/unzip
	media-sound/mpg123
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-CVE-2017-12911.patch )

S="${WORKDIR}"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin mp3gain
}
