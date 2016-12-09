# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit versionator

DESCRIPTION="A dependancy manager for PHP"
HOMEPAGE="https://getcomposer.org"

SRC_URI="https://getcomposer.org/download/${PV}/${PN}.phar -> ${P}.phar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${RDEPEND}
	>=dev-lang/php-5.3.4"
RDEPEND="dev-lang/php[curl]"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}"
	S=${WORKDIR}
}

src_install() {
	mv "${WORKDIR}/${A}" "${WORKDIR}/${PN}"
	dobin ${PN}
}
