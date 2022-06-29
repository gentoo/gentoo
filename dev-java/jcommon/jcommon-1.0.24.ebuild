# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jfree:jcommon:1.0.24"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A free general purpose Java class library that is used in several projects"
HOMEPAGE="http://www.jfree.org/jcommon/"
SRC_URI="https://github.com/jfree/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
