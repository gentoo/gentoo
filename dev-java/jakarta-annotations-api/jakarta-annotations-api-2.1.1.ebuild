# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.annotation:jakarta.annotation-api:2.1.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Annotations API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.ca"
SRC_URI="https://github.com/eclipse-ee4j/${PN/jakarta/common}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-11:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/${P/jakarta/common}"

JAVA_SRC_DIR="api/src/main/java"
