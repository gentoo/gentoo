# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:1.2.7"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Standard Tag Library API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jstl"
SRC_URI="https://github.com/jakartaee/tags/archive/${PV}-RELEASE.tar.gz -> jstl-${PV}.tar.gz"
S="${WORKDIR}/tags-${PV}-RELEASE"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

CP_DEPEND="
	dev-java/javax-el-api:2.2
	dev-java/javax-jsp-api:2.2
	dev-java/javax-servlet-api:2.5
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

JAVA_SRC_DIR="api/src/main/java"
