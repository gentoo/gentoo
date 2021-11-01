# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom el-ri-4.0.0-RELEASE/api/pom.xml --download-uri https://github.com/eclipse-ee4j/el-ri/archive/refs/tags/4.0.0-RELEASE.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jakarta-el-api-4.0.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.el:jakarta.el-api:4.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Expression Language defines an expression language for Java applications"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.el"
SRC_URI="https://github.com/eclipse-ee4j/el-ri/archive/refs/tags/${PV}-RELEASE.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,LICENSE,NOTICE,README}.md )

S="${WORKDIR}"/el-ri-${PV}-RELEASE/api

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="res"

src_prepare() {
	default
	mkdir -p res || die
	cp -r src/main/java/* res || die
	find "${JAVA_RESOURCE_DIRS}" -type f -name '*.java' -exec rm -rf {} + || die "deleting classes failed"
}

src_install() {
	default
	java-pkg-simple_src_install
}
