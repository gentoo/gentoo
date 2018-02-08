# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_COMPAT=( python2_7 )

inherit font python-any-r1

DESCRIPTION="A Helvetica/Times/Courier replacement TrueType font set, courtesy of Red Hat"
HOMEPAGE="https://pagure.io/liberation-fonts"
SRC_URI="!fontforge? ( https://releases.pagure.org/liberation-fonts/${PN}/${PN}-ttf-${PV}.tar.gz )
fontforge? ( https://releases.pagure.org/liberation-fonts/${PN}/${P}.tar.gz )"

KEYWORDS="amd64 arm ~arm64 ia64 ppc x86 ~amd64-linux ~x86-linux ~x64-solaris"
SLOT="0"
LICENSE="OFL-1.1"
IUSE="fontforge X"

FONT_SUFFIX="ttf"

FONT_CONF=( "${FILESDIR}/60-liberation.conf" )

DEPEND="fontforge? (
		${PYTHON_DEPS}
		media-gfx/fontforge
		dev-python/fonttools
	)"
RDEPEND=""

pkg_setup() {
	if use fontforge; then
		FONT_S="${S}/${PN}-ttf-${PV}"
		python-any-r1_pkg_setup
	else
		FONT_S="${WORKDIR}/${PN}-ttf-${PV}"
		S="${FONT_S}"
	fi
	font_pkg_setup
}
