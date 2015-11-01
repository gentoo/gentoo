# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A text-processing Java API that serialize objects to XML and back again"
HOMEPAGE="http://x-stream.github.io"
SRC_URI="http://central.maven.org/maven2/com/thoughtworks/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/kxml:2
	dev-java/xom:0
	dev-java/xpp3:0
	dev-java/cglib:3
	dev-java/dom4j:1
	dev-java/jdom:2
	dev-java/jdom:1.0
	dev-java/joda-time:0
	dev-java/jettison:0"

# This package does need Java 8. See bug 564616.
RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="
	xpp3
	xom
	kxml-2
	jdom-2
	jdom-1.0
	dom4j-1
	cglib-3
	jettison
	joda-time"

# Two drivers for two very old implementations of StAX.
# StAX has been last-rited from Gentoo as it is now part of the Java 6 JDK. 
# See bug 561504. These drivers rely on ancient APIs that aren't maintained
# upstream and may contain security holes.
JAVA_RM_FILES=(
	com/thoughtworks/xstream/io/xml/WstxDriver.java
	com/thoughtworks/xstream/io/xml/BEAStaxDriver.java
)
