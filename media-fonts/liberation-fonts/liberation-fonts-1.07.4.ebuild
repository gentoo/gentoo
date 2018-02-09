# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="A Helvetica/Times/Courier replacement TrueType font set, courtesy of Red Hat"
HOMEPAGE="https://pagure.io/liberation-fonts"
SRC_URI="!fontforge? ( https://releases.pagure.org/liberation-fonts/${PN}/${PN}-ttf-${PV}.tar.gz )
	fontforge? ( https://releases.pagure.org/liberation-fonts/${PN}/${P}.tar.gz )"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2-with-exceptions"
IUSE="fontforge X"

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}/60-liberation.conf" )

DEPEND="fontforge? ( media-gfx/fontforge )"
RDEPEND=""

pkg_setup() {
	if use fontforge; then
		FONT_S="${S}/${PN}-ttf-${PV}"
	else
		FONT_S="${WORKDIR}/${PN}-ttf-${PV}"
		S="${FONT_S}"
	fi
	font_pkg_setup
}
