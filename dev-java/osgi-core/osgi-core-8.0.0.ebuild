# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom osgi.core-8.0.0.pom.xml --download-uri https://repo1.maven.org/maven2/org/osgi/osgi.core/8.0.0/osgi.core-8.0.0-sources.jar --slot 0 --keywords "~amd64 ~x86" --ebuild osgi-core-8.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:osgi.core:8.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Core Release 8, Interfaces and Classes for use in compiling bundles"
HOMEPAGE="https://www.osgi.org/"
SRC_URI="https://repo1.maven.org/maven2/org/osgi/osgi.core/${PV}/osgi.core-${PV}-sources.jar -> ${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Compile dependencies
# POM: osgi.core-${PV}.pom.xml
# org.osgi:osgi.annotation:7.0.0 -> >=dev-java/osgi-annotation-8.0.0:0

DEPEND="
	dev-java/osgi-annotation:0
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="osgi-annotation"
