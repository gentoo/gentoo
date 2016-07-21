# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit qt4-r2

DESCRIPTION="Keep your notes, pictures, ideas, and information in Baskets"
HOMEPAGE="https://bitbucket.org/ridderby/basqet"
SRC_URI="https://basqet.googlecode.com/files/${PN}_${PV}-src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

S=${WORKDIR}/release_${PV}

PATCHES=( "${FILESDIR}/${P}-desktop.patch" )

src_prepare() {
	qt4-r2_src_prepare

	sed -i 's:PREFIX = /usr/local:PREFIX = /usr:' ${PN}.pro || die
}
