# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Many to one page printing utility"
HOMEPAGE="http://www.mesa.nl/"
SRC_URI="
	http://www.mesa.nl/pub/${PN}/${P}.tgz
	https://dev.gentoo.org/~mgorny/dist/${P}-gentoo-patchset.tar.bz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-fix-buildsystem.patch
	"${WORKDIR}"/${P}-gentoo-patchset/01_previous_changes.patch
	"${WORKDIR}"/${P}-gentoo-patchset/10_bts354935_fix_fontdefs.patch
	"${WORKDIR}"/${P}-gentoo-patchset/20_bts416573_manpage_fixes.patch
	"${WORKDIR}"/${P}-gentoo-patchset/30_bts443280_libdir_manpage.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake \
		PREFIX="${EPREFIX}"/usr \
		MANDIR="${EPREFIX}"/usr/share/man/man1
}

src_install() {
	emake \
		PREFIX="${ED}"/usr \
		MANDIR="${ED}"/usr/share/man/man1 install

	rm README.{amiga,OS2} || die
	einstalldocs
	dodoc Encoding.format
}
