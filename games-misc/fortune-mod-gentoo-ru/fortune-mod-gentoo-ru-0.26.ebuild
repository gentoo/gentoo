# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Fortune database of quotes from gentoo.ru forum and gentoo@conference.gentoo.ru"
HOMEPAGE="http://fortunes.gentoo.ru"
SRC_URI="http://slepnoga.googlecode.com/files/gentoo-ru-${PV}.gz
	http://maryasin.name/fortunes-gentoo-ru/gentoo-ru-${PV}.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="games-misc/fortune-mod"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_compile() {
	mv gentoo-ru-${PV} gentoo-ru || die
	strfile gentoo-ru || die
}

src_install() {
	insinto /usr/share/fortune
	doins gentoo-ru gentoo-ru.dat
}
