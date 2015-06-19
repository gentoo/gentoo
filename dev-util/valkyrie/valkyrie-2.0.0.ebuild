# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/valkyrie/valkyrie-2.0.0.ebuild,v 1.5 2015/05/13 09:40:42 ago Exp $

EAPI=3

inherit qt4-r2

DESCRIPTION="Graphical front-end to the Valgrind suite of tools"
HOMEPAGE="http://www.valgrind.org/"
SRC_URI="http://www.valgrind.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-util/valgrind-3.6.0
	dev-qt/qtgui:4
	dev-qt/qtcore:4"
RDEPEND="${DEPEND}"

DOCS=( README )
PATCHES=(
	"${FILESDIR}"/${P}-prefix.patch
	"${FILESDIR}"/${P}-gcc47.patch
)
