# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
KDE_LINGUAS="cs de fr"

inherit kde4-base

DESCRIPTION="Friendly nzb linux usenet binary client"
HOMEPAGE="https://www.linux-apps.com/content/show.php/Kwooty?content=114385"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	kde-plasma/libkworkspace:4
"
RDEPEND="
	${DEPEND}
	app-arch/unrar
	app-arch/par2cmdline
"

DOCS=( README.txt TODO )
