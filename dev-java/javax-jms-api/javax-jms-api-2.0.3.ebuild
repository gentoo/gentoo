# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom api/pom.xml --download-uri https://github.com/jakartaee/messaging/archive/2.0.3-RELEASE.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild javax-jms-api-2.0.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="jakarta.jms:jakarta.jms-api:2.0.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Messaging"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jms"
SRC_URI="https://github.com/jakartaee/messaging/archive/${PV}-RELEASE.tar.gz -> ${P}-RELEASE.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( NOTICE.md README.md )

S="${WORKDIR}/messaging-${PV}-RELEASE"

JAVA_SRC_DIR="api/src/main/java"
