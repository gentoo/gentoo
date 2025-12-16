# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for JVM-based languages"
HOMEPAGE="https://github.com/JetBrains/java-annotations"
SRC_URI="https://github.com/JetBrains/java-annotations/archive/$(ver_rs 3 -).tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN/jetbrains/java}-$(ver_rs 3 -)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR=( src/jvmMain/{java,moduleInfo} )
