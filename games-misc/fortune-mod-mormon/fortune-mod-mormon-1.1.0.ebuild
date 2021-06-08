# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fortune modules from the LDS scriptures (KJV Bible, Book of Mormon, D&C, PGP)"
HOMEPAGE="https://scriptures.nephi.org/"
SRC_URI="mirror://sourceforge/mormon/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

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
