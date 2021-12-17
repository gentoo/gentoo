# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jboss-jms-api_1.1_spec-1.0.1.Final.pom --download-uri https://repo1.maven.org/maven2/org/jboss/spec/javax/jms/jboss-jms-api_1.1_spec/1.0.1.Final/jboss-jms-api_1.1_spec-1.0.1.Final-sources.jar --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jboss-jms-api-1.0.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.jboss.spec.javax.jms:jboss-jms-api_1.1_spec:1.0.1.Final"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSR-000914: Java(TM) Message Service (JMS) 1.1 API"
HOMEPAGE="https://github.com/jboss/jboss-jms-api_spec"
SRC_URI="https://repo1.maven.org/maven2/org/jboss/spec/javax/jms/${PN}_1.1_spec/${PV}.Final/${PN}_1.1_spec-${PV}.Final-sources.jar -> ${P}-sources.jar"

LICENSE="CDDL GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
