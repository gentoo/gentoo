# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

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

src_configure() {
	eqmake4 ${PN}.pro PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
