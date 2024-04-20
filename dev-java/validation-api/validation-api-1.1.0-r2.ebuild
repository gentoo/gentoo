# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bean Validation (JSR-303) API"
HOMEPAGE="https://beanvalidation.org/"
SRC_URI="https://repo1.maven.org/maven2/javax/validation/${PN}/${PV}.Final/${P}.Final-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.8"
DEPEND=">=virtual/jdk-1.8"
