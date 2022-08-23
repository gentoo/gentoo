# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"
MAVEN_ID="org.apache.commons:commons-math3:3.6.1"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Lightweight, self-contained mathematics and statistics components"
HOMEPAGE="https://commons.apache.org/math/"
SRC_URI="https://repo1.maven.org/maven2/org/apache/commons/${MY_PN}/${PV}/${MY_P}-sources.jar"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

JAVA_AUTOMATIC_MODULE_NAME="commons.math3"
