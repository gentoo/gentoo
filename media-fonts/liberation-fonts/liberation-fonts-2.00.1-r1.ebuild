# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/liberation-fonts/liberation-fonts-2.00.1-r1.ebuild,v 1.5 2015/04/08 18:15:03 mgorny Exp $

EAPI=4

PYTHON_COMPAT=( python2_7 )

inherit font python-any-r1

DESCRIPTION="A Helvetica/Times/Courier replacement TrueType font set, courtesy of Red Hat"
HOMEPAGE="https://fedorahosted.org/liberation-fonts"
SRC_URI="!fontforge? ( https://fedorahosted.org/releases/l/i/${PN}/${PN}-ttf-${PV}.tar.gz )
fontforge? ( https://fedorahosted.org/releases/l/i/${PN}/${P}.tar.gz )"

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
