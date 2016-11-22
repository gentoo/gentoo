# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source doc examples"

inherit java-pkg-2 java-pkg-simple

MY_PN="geoip-api-java"

DESCRIPTION="Java library for lookup countries by IP addresses"
HOMEPAGE="https://github.com/maxmind"
SRC_URI="https://github.com/maxmind/${MY_PN}/archive/v${PV}.zip -> ${P}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${MY_PN}-${PV}"

JAVA_SRC_DIR="src"

java_prepare() {
	rm -rv src/test || die
}

src_install() {
	java-pkg-simple_src_install

	dodoc README.md Changes.md

	use examples && java-pkg_doexamples examples/*
}

pkg_postinst() {
	einfo "Country and City data files can be downloaded here:"
	einfo "  http://www.maxmind.com/app/geolitecountry"
	einfo "  http://www.maxmind.com/app/geolitecity"
}
