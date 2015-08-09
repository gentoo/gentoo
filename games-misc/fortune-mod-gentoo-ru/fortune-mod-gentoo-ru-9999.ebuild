# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit mercurial

DESCRIPTION="Fortune database of quotes from gentoo.ru forum and gentoo@conference.gentoo.ru"
HOMEPAGE="http://fortunes.gentoo.ru"
SRC_URI=""
EHG_REPO_URI="https://gentoo-ru-fortunes.slepnoga.googlecode.com/hg"

LICENSE="fairuse"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="games-misc/fortune-mod"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	mv gentoo-ru-9999 gentoo-ru || die
}

src_compile() {
	strfile gentoo-ru || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-ru gentoo-ru.dat
}
