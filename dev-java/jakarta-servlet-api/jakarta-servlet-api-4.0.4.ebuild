# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.servlet:jakarta.servlet-api:4.0.4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Javax servlet API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.servlet"
SRC_URI="https://github.com/jakartaee/servlet/archive/${PV}-RELEASE.tar.gz -> ${P}-RELEASE.tar.gz"

LICENSE="|| ( GPL-2 GPL-2-with-classpath-exception )"
SLOT="4"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/servlet-${PV}-RELEASE"

JAVA_AUTOMATIC_MODULE_NAME="java.servlet"
JAVA_SRC_DIR="api/src/main/java"
JAVA_RESOURCE_DIRS="api/src/main/res"

src_prepare() {
	default
	cp -r api/src/main/{java,res} || die
	find api/src/main/res -type f -name '*.java' -exec rm -rf {} + || die
	java-pkg-2_src_prepare
}
