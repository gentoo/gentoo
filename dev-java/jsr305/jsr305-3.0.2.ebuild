# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for Software Defect Detection in Java"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=305"
SRC_URI="http://central.maven.org/maven2/com/google/code/findbugs/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
