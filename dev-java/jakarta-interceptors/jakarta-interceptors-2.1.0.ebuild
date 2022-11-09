# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom api/pom.xml --download-uri https://github.com/jakartaee/interceptors/archive/2.1.0-RELEASE.tar.gz --slot 0 --keywords "~amd64" --ebuild jakarta-interceptors-2.1.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.interceptor:jakarta.interceptor-api:2.1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Interceptors"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.interceptors"
SRC_URI="https://github.com/jakartaee/interceptors/archive/${PV}-RELEASE.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	dev-java/jakarta-annotations-api:0
	>=virtual/jdk-11:*
"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/interceptors-${PV}-RELEASE"

JAVA_CLASSPATH_EXTRA="jakarta-annotations-api"
JAVA_SRC_DIR="api/src/main/java"
