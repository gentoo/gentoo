# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic

MY_PV="${PV/_/-}"
MY_PV2="${PV/_/~}"
MY_P="${PN}-${MY_PV}"
MY_P2="${PN}-${MY_PV2}"

DESCRIPTION="library to use arbitrary fonts in OpenGL applications"
HOMEPAGE="http://ftgl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=">=media-libs/freetype-2.0.9
	virtual/opengl
	virtual/glu
	media-libs/freeglut"
RDEPEND="${DEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P2}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
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
	rm -r "${ED%/}"/usr/share/doc/ftgl || die
	find "${ED}" -name '*.la' -delete || die
}
