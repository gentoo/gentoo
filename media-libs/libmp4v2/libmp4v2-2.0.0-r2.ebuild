# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/lib}

inherit libtool

DESCRIPTION="Functions for accessing ISO-IEC:14496-1:2001 MPEG-4 standard"
HOMEPAGE="https://code.google.com/p/mp4v2/"
SRC_URI="https://mp4v2.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="static-libs utils"
# Tests need DejaGnu but are non-existent (just an empty framework)
RESTRICT="test"

BDEPEND="utils? ( sys-apps/help2man )"

DOCS=( doc/{Authors,BuildSource,Documentation,ReleaseNotes,ToolGuide}.txt README )

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-gcc7.patch"
	"${FILESDIR}/${P}-mp4tags-corruption.patch"
	"${FILESDIR}/${P}-clang.patch"
	"${FILESDIR}/${P}-CVE-2018-14054.patch"
	"${FILESDIR}/${P}-CVE-2018-14325.patch"
	"${FILESDIR}/${P}-CVE-2018-14379.patch"
	"${FILESDIR}/${P}-CVE-2018-14403.patch"
	"${FILESDIR}/${P}-unsigned-int-cast.patch"
)

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf \
		--disable-gch \
		$(use_enable utils util) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
