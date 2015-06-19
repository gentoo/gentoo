# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kfilebox/kfilebox-0.4.9.ebuild,v 1.2 2014/04/23 22:41:43 creffett Exp $

EAPI=5

LANGS="ar br cs de el es fr gl it lt nl pl pt ru si tr zh"
inherit qt4-r2

MY_P="${PN}_${PV}"

DESCRIPTION="KDE dropbox client"
HOMEPAGE="http://kdropbox.deuteros.es/"
SRC_URI="http://dev.gentoo.org/~tampakrap/tarballs/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE=""

for name in ${LANGS} ; do IUSE+="linguas_$name " ; done
unset name

DEPEND="kde-base/kdelibs"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	qt4-r2_src_install

	for lang in ${LANGS}; do
		if ! has ${lang} ${LINGUAS}; then
			rm -rf "${D}"/usr/share/locale/${lang} || die
		fi
	done
}
