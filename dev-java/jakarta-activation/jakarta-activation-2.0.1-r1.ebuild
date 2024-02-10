# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.sun.activation:jakarta.activation:2.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Activation"
HOMEPAGE="https://jakartaee.github.io/jaf-api/"
SRC_URI="https://github.com/jakartaee/jaf-api/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jaf-api-${PV}/activation"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-11:* "
RDEPEND=">=virtual/jre-1.8:* "

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
