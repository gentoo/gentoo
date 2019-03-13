# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSR 250 Common Annotations"
HOMEPAGE="https://jcp.org/en/jsr/detail?id=250"
SRC_URI="https://repo1.maven.org/maven2/javax/annotation/javax.annotation-api/${PV}/javax.annotation-api-${PV}-sources.jar -> ${P}.jar"

LICENSE="|| ( CDDL GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux"

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7"
