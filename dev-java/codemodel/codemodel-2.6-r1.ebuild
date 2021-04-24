# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library for code generators"
HOMEPAGE="https://javaee.github.io/jaxb-codemodel/"
SRC_URI="https://repo.maven.apache.org/maven2/com/sun/${PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"
