# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Multi octet character encoding handling library"
HOMEPAGE="http://pub.ks-and-ks.ne.jp/prog/libmoe/"
SRC_URI="http://pub.ks-and-ks.ne.jp/prog/pub/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ~riscv sparc x86"
IUSE="static-libs"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

HTML_DOCS=( ${PN}.shtml )
PATCHES=(
	"${FILESDIR}/${PN}-gentoo.patch"
	"${FILESDIR}/${PN}-gcc-5.patch"  # taken from Debian
)

src_prepare() {
	default

	sed -i \
		-e "/^PREFIX=/s|=.*|=${EPREFIX}/usr|" \
		-e "/^LIBSODIR=/s|=.*|=\${PREFIX}/$(get_libdir)|" \
		-e "/^MANDIR=/s|=.*|=\${PREFIX}/share/man|" \
		-e "/^MANCOMPR=/s|=.*|=cat|" \
		-e "/^MANX=/s|=.*|=|" \
		-e "/^\(CC\|LD\)=/s|=.*|=$(tc-getCC)|" \
		-e "/^CPP=/s|=.*|=$(tc-getCPP)|" \
		-e "/^RANLIB=/s|=.*|=$(tc-getRANLIB)|" \
		-e "/^AR=/s|=.*|=$(tc-getAR)|" \
		Makefile || die
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.a' -delete || die
}
