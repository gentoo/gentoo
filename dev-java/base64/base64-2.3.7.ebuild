# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/base64/base64-2.3.7.ebuild,v 1.2 2013/10/14 17:35:55 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="A Base64 encoder written in java"
HOMEPAGE="http://iharder.sourceforge.net/current/java/base64/"
SRC_URI="mirror://sourceforge/iharder/${PN}/${MY_PV}/${PN^}-v${PV}.zip -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${PN^}-v${PV}"
JAVA_SRC_DIR="${S}"

src_prepare() {
	rm -r "${S}"/api || die
	mkdir -p "${S}/net/iharder" || die
	cp "${S}"/*.java "${S}/net/iharder" || die
	sed -i '1i package net.iharder;' "${S}"/net/iharder/*.java || die
}

src_compile() {
	local build_dir="${S}/build"
	mkdir ${build_dir} || die
	ejavac -nowarn -d ${build_dir} $(find -name "*.java")
	javadoc -d api -quiet *.java || die "javadoc failed"
}

src_install() {
	jar cf "${PN}.jar" -C "${S}/build" . || die "jar failed"
	java-pkg_dojar "${PN}.jar"

	use doc && java-pkg_dohtml -r api/
	use source && java-pkg_dosrc *.java
}
