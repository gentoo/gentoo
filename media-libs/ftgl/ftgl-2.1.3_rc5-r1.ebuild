# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PV="${PV/_/-}"
MY_PV2="${PV/_/\~}"
MY_P="${PN}-${MY_PV}"
MY_P2="${PN}-${MY_PV2}"

DESCRIPTION="library to use arbitrary fonts in OpenGL applications"
HOMEPAGE="https://sourceforge.net/projects/ftgl/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P2}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	media-libs/freeglut
	>=media-libs/freetype-2.0.9
	virtual/opengl
	virtual/glu
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	strip-flags # ftgl is sensitive - bug #112820
	econf $(use_enable static-libs static)
}

src_install() {
	local DOCS=( AUTHORS BUGS ChangeLog NEWS README TODO docs/projects_using_ftgl.txt)

	default

	rm -r "${ED}"/usr/share/doc/ftgl || die
	find "${ED}" -name '*.la' -delete || die
}
