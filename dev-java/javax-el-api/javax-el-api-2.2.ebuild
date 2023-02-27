# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="javax.el:el-api:2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Expression Language API"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://repo1.maven.org/maven2/javax/el/el-api/${PV}/el-api-${PV}-sources.jar"

# https://repo1.maven.org/maven2/javax/el/el-api/2.2/el-api-2.2.pom
LICENSE="CDDL GPL-2"
SLOT="2.2"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir resources || die
	cp --parents javax/el/*.properties resources || die
}
