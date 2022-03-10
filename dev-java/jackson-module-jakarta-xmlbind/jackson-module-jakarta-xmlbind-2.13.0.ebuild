# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/jackson-modules-base/archive/refs/tags/jackson-modules-base-2.13.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jackson-xmlbind-annotations-2.13.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.fasterxml.jackson.module:jackson-module-jakarta-xmlbind-annotations:2.13.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Support for using Jakarta XML Bind (aka JAXB 3.0) annotations"
HOMEPAGE="https://github.com/FasterXML/jackson-modules-base"
SRC_URI="https://github.com/FasterXML/jackson-modules-base/archive/refs/tags/jackson-modules-base-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# We don't have jaxb-runtime:3.0.1
RESTRICT="test"

# Common dependencies
# POM: pom.xml
# com.fasterxml.jackson.core:jackson-annotations:2.13.0 -> >=dev-java/jackson-annotations-2.13.0:2
# com.fasterxml.jackson.core:jackson-core:2.13.0 -> >=dev-java/jackson-core-2.13.0:0
# com.fasterxml.jackson.core:jackson-databind:2.13.0 -> >=dev-java/jackson-databind-2.13.0:0
# jakarta.activation:jakarta.activation-api:1.2.1 -> >=dev-java/jakarta-activation-api-1.2.2:1
# jakarta.xml.bind:jakarta.xml.bind-api:3.0.1 -> >=dev-java/jaxb-api-3.0.1:3

CP_DEPEND="
	dev-java/jackson-annotations:2
	dev-java/jackson-core:0
	dev-java/jackson-databind:0
	dev-java/jakarta-activation-api:1
	dev-java/jaxb-api:3
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.glassfish.jaxb:jaxb-runtime:3.0.1 -> !!!groupId-not-found!!!

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
#	test? (
#		!!!groupId-not-found!!!
#	)
#"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/jackson-modules-base-jackson-modules-base-${PV}/jakarta-xmlbind/"

JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

# JAVA_TEST_GENTOO_CLASSPATH="junit-4,!!!groupId-not-found!!!"
# JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.module.jakarta.xmlbind:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.module:g' \
		-e "s:@projectartifactid@:jackson-module-jakarta-xmlbind-annotations:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/module/jakarta/xmlbind/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/module/jakarta/xmlbind/PackageVersion.java" || die

	# This is an ugly hack, but ...
	#	src/moditect/module-info.java:13: error: cannot find symbol
	#	        com.fasterxml.jackson.module.jakarta.xmlbind.JakartaXmlBindModule;
	#	                                                    ^
	#	  symbol:   class JakartaXmlBindModule
	#	  location: package com.fasterxml.jackson.module.jakarta.xmlbind
	sed -e '/JakartaXmlBindModule/d' \
		-e '/provides/d' \
		-i src/moditect/module-info.java || die
}
