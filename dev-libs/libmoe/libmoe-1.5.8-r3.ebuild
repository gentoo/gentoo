# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Multi octet character encoding handling library"
HOMEPAGE="http://pub.ks-and-ks.ne.jp/prog/libmoe/"
SRC_URI="http://pub.ks-and-ks.ne.jp/prog/pub/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

HTML_DOCS=( libmoe.shtml )
PATCHES=(
	"${FILESDIR}/${PN}-gentoo.patch"
	"${FILESDIR}/${PN}-gcc-5.patch"  # taken from Debian
)

src_prepare() {
	default

	sed -i \
		-e "/^PREFIX=/s:=.*:=${EPREFIX}/usr:" \
		-e "/^LIBSODIR=/s:=.*:=\$\{PREFIX}/$(get_libdir):" \
		-e "/^MANDIR=/s:=.*:=\$\{PREFIX}/share/man:" \
		-e "s:=gcc:=$(tc-getCC):" \
		-e "/^AR=/s:=ar:=$(tc-getAR):" \
		Makefile || die
}
