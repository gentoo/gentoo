# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="GDL library from D. Fannings IDL courses"
HOMEPAGE="http://www.idlcoyote.com/"
SRC_URI="http://www.idlcoyote.com/programs/zip_files/coyoteprograms.zip -> ${P}.zip"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-lang/gdl"

S="${WORKDIR}/coyote"

PATCHES=(
	"${FILESDIR}/${PN}-cgloadct.patch"
	"${FILESDIR}/${PN}-gdl-fixes.patch"
)

src_install() {
	dodoc README.txt
	newdoc public/README.txt README-public.txt
	rm README.txt public/README.txt || die
	insinto /usr/share/gnudatalanguage/coyote
	doins -r *
}
