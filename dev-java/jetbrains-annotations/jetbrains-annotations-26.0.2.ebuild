# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jetbrains:annotations:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Annotations for JVM-based languages"
HOMEPAGE="https://github.com/JetBrains/java-annotations"
SRC_URI="https://github.com/JetBrains/java-annotations/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/jetbrains/java}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR=( src/jvmMain/{java,moduleInfo} )
