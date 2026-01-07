# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.inject:javax.inject:1"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Dependency injection for Java (JSR-330)"
HOMEPAGE="https://github.com/javax-inject/javax-inject"
SRC_URI="http://central.maven.org/maven2/javax/inject/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
