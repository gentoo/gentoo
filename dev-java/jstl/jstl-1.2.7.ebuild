# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.glassfish.web:javax.servlet.jsp.jstl:1.2.7"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Standard Tag Library API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jstl"
SRC_URI="https://github.com/jakartaee/tags/archive/${PV}-RELEASE.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/tags-${PV}-RELEASE"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

CP_DEPEND="
	dev-java/javax-el-api:2.2
	dev-java/javax-jsp-api:2.2
	dev-java/javax-servlet-api:2.5
	dev-java/jstl-api:0
	dev-java/xalan:0
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

DOCS=(
	CONTRIBUTING.md
	NOTICE.md
	README.md
)

JAVA_JAR_FILENAME="jstl-impl.jar"
JAVA_RESOURCE_DIRS="impl/src/main/resources"
JAVA_SRC_DIR="impl/src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	# java-pkg-simple expects resource files in JAVA_RESOURCE_DIRS
	cp -r impl/src/main/java/* impl/src/main/resources || die
	find impl/src/main/resources -type f \
		\( -name '*.java' \
		-o -name '*.txt' \
		-o -name '*Parser.jj' \
		-o -name 'spath.tld' \
		\) -exec rm -rf {} + || die "deleting classes failed"
}
