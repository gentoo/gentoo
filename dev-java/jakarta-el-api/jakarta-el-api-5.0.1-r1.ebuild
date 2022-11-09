# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom api/pom.xml --download-uri https://github.com/jakartaee/expression-language/archive/5.0.1-RELEASE-api.tar.gz --slot 0 --keywords "~amd64" --ebuild jakarta-el-api-5.0.1.ebuild

EAPI=8

# No tests since we don't have junit-jupiter
JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.el:jakarta.el-api:5.0.1"
# JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Expression Language defines an expression language for Java applications"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.el"
SRC_URI="https://github.com/jakartaee/expression-language/archive/${PV}-RELEASE-api.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"
SLOT="5.0"

DEPEND=">=virtual/jdk-11:*"
# <release>11</release>
# https://github.com/jakartaee/expression-language/blob/5.0.1-RELEASE-api/api/pom.xml#L143
RDEPEND=">=virtual/jre-11:*"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/expression-language-${PV}-RELEASE-api"

JAVA_SRC_DIR="api/src/main/java"
