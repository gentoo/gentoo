# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"
MAVEN_ID="ch.qos.cal10n:cal10n-api:0.8.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="java library for writing localized messages using resource bundle"
HOMEPAGE="http://cal10n.qos.ch/"
SRC_URI="http://repo1.maven.org/maven2/ch/qos/${PN}/${PN}-api/${PV}/${PN}-api-${PV}-sources.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}"

java_prepare() {
	mkdir -p "${S}"/target/classes || die
	mv "${S}"/META-INF "${S}"/target/classes || die
}
