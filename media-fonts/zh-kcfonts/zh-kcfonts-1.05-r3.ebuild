# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font toolchain-funcs

MY_P="${P#zh-}"

DESCRIPTION="Kuo Chauo Chinese Fonts collection in BIG5 encoding"
# no real homepage exists, but this was written by Taiwanese FreeBSD devs
HOMEPAGE="http://freebsd.sinica.edu.tw/"
SRC_URI="
	ftp://freebsd.sinica.edu.tw/pub/distfiles/${MY_P}.tar.gz
	ftp://wm28.csie.ncu.edu.tw/pub/distfiles/${MY_P}.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${P}-freebsd-aa_ad.patch.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86"
IUSE=""
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="x11-apps/bdftopcf"

S="${WORKDIR}"

PATCHES=(
	"${WORKDIR}"/${P}-freebsd-aa_ad.patch
	"${FILESDIR}"/${MY_P}-code-fixups.patch
	"${FILESDIR}"/${MY_P}-parallel-make.patch
)

FONT_SUFFIX="pcf.gz"
DOCS="00README Xdefaults.*"

src_compile() {
	emake CC="$(tc-getCC)"
}
