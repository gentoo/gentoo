# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Fortune modules from the LDS scriptures (KJV Bible, Book of Mormon, D&C, PGP)"
HOMEPAGE="http://scriptures.nephi.org/"
SRC_URI="mirror://sourceforge/mormon/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc64 ~sh ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="
	games-misc/fortune-mod
	games-misc/fortune-mod-scriptures
"

src_install() {
	dodoc ChangeLog README
	insinto /usr/share/fortune
	doins mods/dc mods/dc.dat mods/mormon mods/mormon.dat mods/pgp
	doins mods/scriptures.dat mods/scriptures mods/aof.dat mods/aof
}
