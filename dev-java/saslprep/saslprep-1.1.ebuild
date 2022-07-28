# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.ongres.stringprep:saslprep:1.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SASLprep: Stringprep Profile for User Names and Passwords"
HOMEPAGE="https://gitlab.com/ongresinc/stringprep"
SRC_URI="https://repo1.maven.org/maven2/com/ongres/stringprep/saslprep/${PV}/saslprep-${PV}-sources.jar"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*
	dev-java/stringprep:0"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="stringprep"
