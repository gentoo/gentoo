# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:org.osgi.service.log:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Companion Code for org.osgi.service.log"
HOMEPAGE="https://www.osgi.org/"
SRC_URI="https://repo1.maven.org/maven2/org/osgi/org.osgi.service.log/${PV}/org.osgi.service.log-${PV}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

CP_DEPEND="dev-java/osgi-core:0"

DEPEND="${CP_DEPEND}
	dev-java/osgi-annotation:0
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_AUTOMATIC_MODULE_NAME="org.osgi.service.log"
JAVA_CLASSPATH_EXTRA="osgi-annotation"
