# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Dependency injection for Java (JSR-330)"
HOMEPAGE="https://code.google.com/p/atinject/"
SRC_URI="http://central.maven.org/maven2/javax/inject/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 arm64 ~ppc64 ~x86 ~amd64-linux"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
