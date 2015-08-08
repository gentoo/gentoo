# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-opt-2 versionator

MY_P="${PN}-${PV}.jar"
MY_P="${MY_P/_/}"
MY_P="${MY_P/./_}"
MY_P="${MY_P/./_}"

DESCRIPTION="Yet another Java HylaFAX Plus Client"
HOMEPAGE="http://www.yajhfc.de/"
SRC_URI="http://download.yajhfc.de/releases/${MY_P}"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS=""
IUSE=""

COMMON_DEPEND=">=virtual/jdk-1.4"
RDEPEND="${COMMON_DEPEND} >=virtual/jre-1.4"
DEPEND="${COMMON_DEPEND} virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	echo "java -jar /usr/bin/${MY_P}" > "${WORKDIR}"/h.h
	newbin "${WORKDIR}/h.h" "yajhfc"
	newbin "${DISTDIR}/${MY_P}" "${MY_P}"
}
