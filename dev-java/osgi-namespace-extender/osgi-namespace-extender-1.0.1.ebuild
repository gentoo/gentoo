# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom org.osgi.namespace.extender-1.0.1.pom.xml --download-uri https://repo1.maven.org/maven2/org/osgi/org.osgi.namespace.extender/1.0.1/org.osgi.namespace.extender-1.0.1-sources.jar --slot 0 --keywords "~amd64 ~x86" --ebuild osgi-namespace-extender-1.0.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:org.osgi.namespace.extender:1.0.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Companion Code for org.osgi.namespace.extender Version 1.0.1."
HOMEPAGE="https://www.osgi.org/"
SRC_URI="https://repo1.maven.org/maven2/org/osgi/org.osgi.namespace.extender/${PV}/org.osgi.namespace.extender-${PV}-sources.jar -> ${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="osgi-annotation,osgi-core"
