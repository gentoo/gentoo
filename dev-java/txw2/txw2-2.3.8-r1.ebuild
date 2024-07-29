# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.glassfish.jaxb:txw2:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="TXW is a library that allows you to write XML documents"
HOMEPAGE="https://eclipse-ee4j.github.io/jaxb-ri/"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-ri/archive/${PV}-RI.tar.gz -> jaxb-ri-${PV}.tar.gz"
S="${WORKDIR}/jaxb-ri-${PV}-RI/jaxb-ri/txw/runtime"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-11:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
