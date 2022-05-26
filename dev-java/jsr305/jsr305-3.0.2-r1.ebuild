# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source doc"
MAVEN_ID="com.google.code.findbugs:jsr305:3.0.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for Software Defect Detection in Java"
HOMEPAGE="https://jcp.org/en/jsr/detail?id=305"
SRC_URI="https://repo1.maven.org/maven2/com/google/code/findbugs/jsr305/${PV}/jsr305-${PV}-sources.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
