# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jboss/jboss-jms-api_spec/archive/jboss-jms-api_1.1_spec-1.0.1.Final.tar.gz --slot 1.1 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jboss-jms-api-1.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jboss.spec.javax.jms:jboss-jms-api_1.1_spec:1.0.1.Final"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSR-000914: Java(TM) Message Service (JMS) 1.1 API"
HOMEPAGE="https://github.com/jboss/jboss-jms-api_spec"
SRC_URI="https://github.com/jboss/${PN}_spec/archive/${PN}_1.1_spec-${PV}.Final.tar.gz -> ${P}.tar.gz"

LICENSE="CDDL GPL-2-with-classpath-exception"
SLOT="1.1"
KEYWORDS="amd64 arm64 ppc64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( LICENSE README )

S="${WORKDIR}/${PN}_spec-${PN}_1.1_spec-${PV}.Final"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
