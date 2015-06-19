# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/esco/esco-0.512.ebuild,v 1.1 2013/02/01 10:43:49 pinkbyte Exp $

EAPI=5

MY_PN="${PN}-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Combine interpreter of esoteric languages"
HOMEPAGE="http://esco.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gmp linguas_ru"

DEPEND="gmp? ( dev-libs/gmp )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README TODO docs/basics.txt )

src_configure() {
	econf $(use_with gmp)
}

src_install() {
	default
	use linguas_ru && dodoc docs/README_RU.utf8
}
