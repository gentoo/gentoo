# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom biz.aQute.bnd.annotation-6.3.1.pom --download-uri https://repo1.maven.org/maven2/biz/aQute/bnd/biz.aQute.bnd.annotation/6.3.1/biz.aQute.bnd.annotation-6.3.1-sources.jar --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild aqute-bnd-annotation-6.3.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bnd.annotation:6.3.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="bnd Annotations Library"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://repo1.maven.org/maven2/biz/aQute/bnd/biz.aQute.bnd.annotation/${PV}/biz.aQute.bnd.annotation-${PV}-sources.jar"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: biz.aQute.bnd.annotation-${PV}.pom
# org.osgi:org.osgi.resource:1.0.0 -> !!!artifactId-not-found!!!
# org.osgi:org.osgi.service.serviceloader:1.0.0 -> !!!artifactId-not-found!!!

CP_DEPEND="dev-java/osgi-annotation:0"

# Compile dependencies
# POM: biz.aQute.bnd.annotation-${PV}.pom
# org.osgi:org.osgi.namespace.extender:1.0.1 -> !!!artifactId-not-found!!!
# org.osgi:org.osgi.namespace.service:1.0.0 -> !!!artifactId-not-found!!!
# org.osgi:osgi.annotation:8.1.0 -> >=dev-java/osgi-annotation-8.1.0:0

DEPEND=">=virtual/jdk-1.8:*
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="osgi-cmpn-8,osgi-core"
JAVA_SRC_DIR="."
