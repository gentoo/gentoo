# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom common-annotations-api-2.0.0/api/pom.xml --download-uri https://github.com/eclipse-ee4j/common-annotations-api/archive/refs/tags/2.0.0.tar.gz --slot 0 --keywords "" --ebuild common-annotations-api-2.0.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.annotation:jakarta.annotation-api:2.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Annotations API"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.ca"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,LICENSE,NOTICE,README}.md )

S="${WORKDIR}/${P}/api"

JAVA_SRC_DIR="src"

src_install() {
	default
	java-pkg-simple_src_install
}
