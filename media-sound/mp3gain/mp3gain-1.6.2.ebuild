# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P//./_}"

DESCRIPTION="Analyze and adjust MP3 files to same volume"
HOMEPAGE="https://mp3gain.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}-src.zip"
S="${WORKDIR}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

BDEPEND="app-arch/unzip"
RDEPEND="media-sound/mpg123"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.6.2-CVE-2019-18359-plus.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin mp3gain
}
