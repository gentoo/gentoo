# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit versionator

MY_PV="$(replace_version_separator 1 '-')EST"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Elle Stone's well-behaved RGB and grey ICC profiles"
HOMEPAGE="http://ninedegreesbelow.com/photography/lcms-make-icc-profiles.html"
SRC_URI="https://github.com/ellelstone/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

src_install() {
	default

	insinto /usr/share/color/icc/ellestone
	doins profiles/*.icc
}
